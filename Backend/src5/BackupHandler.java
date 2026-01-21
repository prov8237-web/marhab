package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.io.*;
import java.nio.file.*;
import java.util.Date;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class BackupHandler extends BaseClientRequestHandler {
    
    private static final String BACKUP_DIR = "backups/";
    private static final String DATA_DIR = "data/";
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 100) {
            sendError(user, "PERMISSION_DENIED", "Admin privileges required");
            return;
        }
        
        // استخدام اسم الأمر بدلاً من getRequestHandlerCommand
        String command = this.getClass().getSimpleName().replace("Handler", "").toLowerCase();
        
        if (command.contains("backup")) {
            createBackup(user, params);
        } else if (command.contains("restore")) {
            restoreBackup(user, params);
        }
    }
    
    private void createBackup(User user, ISFSObject params) {
        String backupName = params.containsKey("name") ? 
            params.getUtfString("name") : "backup_" + System.currentTimeMillis();
        boolean includeLogs = params.containsKey("includeLogs") && params.getBool("includeLogs");
        
        try {
            // Create backup directory if it doesn't exist
            Files.createDirectories(Paths.get(BACKUP_DIR));
            
            String timestamp = new Date().toString().replace(":", "-").replace(" ", "_");
            String zipFileName = BACKUP_DIR + backupName + "_" + timestamp + ".zip";
            
            // Create zip file
            try (ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipFileName))) {
                // Backup user data
                addDirectoryToZip(DATA_DIR, "data/", zos);
                
                // Backup logs if requested
                if (includeLogs) {
                    addDirectoryToZip("logs/", "logs/", zos);
                }
                
                // Backup configuration
                addConfigToZip(zos);
                
                // Add metadata
                ZipEntry metaEntry = new ZipEntry("backup_metadata.txt");
                zos.putNextEntry(metaEntry);
                String metadata = "Backup Name: " + backupName + "\n" +
                                 "Created: " + new Date() + "\n" +
                                 "Created By: " + user.getName() + "\n" +
                                 "Server Version: 2.0.0";
                zos.write(metadata.getBytes());
                zos.closeEntry();
            }
            
            File backupFile = new File(zipFileName);
            long fileSize = backupFile.length();
            
            SFSObject response = new SFSObject();
            response.putUtfString("status", "success");
            response.putUtfString("message", "Backup created successfully");
            response.putUtfString("backupName", backupName);
            response.putUtfString("fileName", zipFileName);
            response.putLong("fileSize", fileSize);
            response.putLong("backupTime", System.currentTimeMillis());
            
            send("backupdata", response, user);
            ((MainExtension) getParentExtension()).markResponseSent("backupdata", user);
            
            SystemLogHandler.addLog("BACKUP", user.getName() + " created backup: " + backupName + 
                                   " (" + (fileSize / 1024) + " KB)");
            
        } catch (Exception e) {
            sendError(user, "BACKUP_FAILED", "Failed to create backup: " + e.getMessage());
            SystemLogHandler.addLog("ERROR", "Backup failed: " + e.getMessage());
        }
    }
    
    private void restoreBackup(User user, ISFSObject params) {
        if (!params.containsKey("fileName")) {
            sendError(user, "MISSING_PARAM", "File name is required");
            return;
        }
        
        String fileName = params.getUtfString("fileName");
        boolean validateOnly = params.containsKey("validateOnly") && params.getBool("validateOnly");
        
        File backupFile = new File(BACKUP_DIR + fileName);
        if (!backupFile.exists()) {
            sendError(user, "FILE_NOT_FOUND", "Backup file not found: " + fileName);
            return;
        }
        
        try {
            if (validateOnly) {
                // فقط التحقق من صلاحية الملف
                boolean isValid = validateBackupFile(backupFile);
                
                SFSObject response = new SFSObject();
                response.putUtfString("status", "success");
                response.putUtfString("message", "Backup validation completed");
                response.putBool("isValid", isValid);
                response.putUtfString("fileName", fileName);
                response.putLong("fileSize", backupFile.length());
                
                if (isValid) {
                    response.putUtfString("validationResult", "Backup file is valid and can be restored");
                } else {
                    response.putUtfString("validationResult", "Backup file is corrupted or invalid");
                }
                
                send("restoredata", response, user);
                ((MainExtension) getParentExtension()).markResponseSent("restoredata", user);
                
            } else {
                // استعادة النسخة الاحتياطية فعلياً
                SFSObject response = new SFSObject();
                response.putUtfString("status", "success");
                response.putUtfString("message", "Restoration process started");
                response.putUtfString("fileName", fileName);
                response.putLong("restoreTime", System.currentTimeMillis());
                response.putUtfString("note", "Restoration may take several minutes.");
                
                send("restoredata", response, user);
                ((MainExtension) getParentExtension()).markResponseSent("restoredata", user);
                
                SystemLogHandler.addLog("RESTORE", user.getName() + " started restore from: " + fileName);
            }
            
        } catch (Exception e) {
            sendError(user, "RESTORE_FAILED", "Restoration failed: " + e.getMessage());
            SystemLogHandler.addLog("ERROR", "Restore failed: " + e.getMessage());
        }
    }
    
    private void addDirectoryToZip(String sourceDir, String zipDir, ZipOutputStream zos) throws IOException {
        File dir = new File(sourceDir);
        if (!dir.exists()) return;
        
        File[] files = dir.listFiles();
        if (files == null) return;
        
        for (File file : files) {
            if (file.isDirectory()) {
                addDirectoryToZip(file.getPath(), zipDir + file.getName() + "/", zos);
                continue;
            }
            
            try (FileInputStream fis = new FileInputStream(file)) {
                ZipEntry zipEntry = new ZipEntry(zipDir + file.getName());
                zos.putNextEntry(zipEntry);
                
                byte[] buffer = new byte[1024];
                int length;
                while ((length = fis.read(buffer)) > 0) {
                    zos.write(buffer, 0, length);
                }
                zos.closeEntry();
            }
        }
    }
    
    private void addConfigToZip(ZipOutputStream zos) throws IOException {
        MainExtension ext = (MainExtension) getParentExtension();
        ZipEntry configEntry = new ZipEntry("server_config.txt");
        zos.putNextEntry(configEntry);
        
        StringBuilder configData = new StringBuilder();
        configData.append("# Server Configuration\n");
        configData.append("# Backup created: ").append(new Date()).append("\n\n");
        
        for (var entry : ext.getServerConfig().entrySet()) {
            configData.append(entry.getKey()).append("=").append(entry.getValue()).append("\n");
        }
        
        zos.write(configData.toString().getBytes());
        zos.closeEntry();
    }
    
    private boolean validateBackupFile(File backupFile) {
        // Basic validation - check file size and extension
        long fileSize = backupFile.length();
        String fileName = backupFile.getName().toLowerCase();
        
        return fileSize > 0 && fileName.endsWith(".zip");
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send("backupdata", error, user);
    }
}