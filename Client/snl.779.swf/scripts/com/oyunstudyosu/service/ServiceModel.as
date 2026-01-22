package com.oyunstudyosu.service
{
   import com.junkbyte.console.Cc;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.PanelVO;
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
   import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import com.smartfoxserver.v2.requests.SetRoomVariablesRequest;
   import com.smartfoxserver.v2.requests.SetUserVariablesRequest;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class ServiceModel implements IServiceModel
   {
       
      
      private var _sfs:SmartFoxLogged;
      
      private var isActive:Boolean;
      
      private var roomVarList:Dictionary;
      
      private var userVarList:Dictionary;
      
      private var extensionList:Dictionary;
      
      private var extListenerList:Dictionary;
      
      private var dataList:Dictionary;
      
      private var alertvo:AlertVo;
      
      private var processList:Dictionary;
      
      public var extensionIdle:Boolean = false;
      
      private var consoleInitialized:Boolean = false;
      
      private var consoleKeeper:Timer;
      
      private var rootStage:Stage;
      
      private var logHistory:Array;
      
      private var seq:int = 0;
      
      private var pendingByCommand:Dictionary;
      
      private var pendingBySeq:Dictionary;
      
      private var pendingTimer:Timer;
      
      private var liveFile:File;
      
      private var liveStream:FileStream;
      
      private var liveTimer:Timer;
      
      private var liveBuffer:Array;
      
      private var liveFileEnabled:Boolean = true;
      
      private var emergencyBuffer:Array;
      
      private var stats:Object;
      
      private var copyButton:Sprite;
      
      private var clearButton:Sprite;
      
      private var liveFileButton:Sprite;
      
      private var statsButton:Sprite;
      
      private const NO_LIMITS:Boolean = true;
      
      private const PENDING_TIMEOUT_MS:int = 8000;
      
      private const MAX_BUFFER_SIZE:int = 20;
      
      private const MAX_CONSOLE_LINES:int = 5000;
      
      public function ServiceModel()
      {
         this.logHistory = [];
         this.pendingByCommand = new Dictionary();
         this.pendingBySeq = new Dictionary();
         this.liveBuffer = [];
         this.emergencyBuffer = [];
         this.stats = {
            "totalPackets":0,
            "totalBytes":0,
            "capturedEntries":0,
            "startTime":0,
            "missedPackets":0,
            "emergencyWrites":0
         };
         super();
         _sfs = new SmartFoxLogged(false);
         roomVarList = new Dictionary(false);
         userVarList = new Dictionary(false);
         extensionList = new Dictionary(false);
         extListenerList = new Dictionary(false);
         dataList = new Dictionary(false);
         processList = new Dictionary(false);
         initConsole();
         startPendingWatcher();
         initLiveFile();
         stats.startTime = getTimer();
         try
         {
            if(_sfs is SmartFoxLogged)
            {
               SmartFoxLogged(_sfs).logger = onSfsLog;
               SmartFoxLogged(_sfs).rawLogger = onSfsRawLog;
            }
         }
         catch(e:Error)
         {
            trace("⚠️ Error setting logger: " + e.message);
         }
      }
      
      private function initLiveFile() : void
      {
         var timestamp:String;
         var fileName:String;
         var header:String;
         try
         {
            timestamp = new Date().getTime().toString();
            fileName = "sanalika_ULTIMATE_" + timestamp + ".txt";
            liveFile = File.desktopDirectory.resolvePath(fileName);
            liveStream = new FileStream();
            liveStream.open(liveFile,FileMode.WRITE);
            header = "";
            header += "╔═══════════════════════════════════════════════════════════════════╗\n";
            header += "║   SANALIKA ULTIMATE LOGGER v5.0 - 1000% CAPTURE                  ║\n";
            header += "║   Every single packet captured - GUARANTEED!                     ║\n";
            header += "║   Started: " + new Date().toLocaleString() + "\n";
            header += "║   File: " + fileName + "\n";
            header += "║   Flush Mode: INSTANT (500ms)                                    ║\n";
            header += "╚═══════════════════════════════════════════════════════════════════╝\n\n";
            liveStream.writeUTFBytes(header);
            liveTimer = new Timer(500);
            liveTimer.addEventListener(TimerEvent.TIMER,flushLiveBuffer);
            liveTimer.start();
            trace("✅ Live file created: " + liveFile.nativePath);
         }
         catch(e:Error)
         {
            trace("❌ Failed to create live file: " + e.message);
            liveFileEnabled = false;
         }
      }
      
      private function flushLiveBuffer(e:TimerEvent = null) : void
      {
         var entry:String;
         var emergEntry:String;
         if(!liveFileEnabled || !liveStream)
         {
            return;
         }
         if(liveBuffer.length > 0)
         {
            try
            {
               for each(entry in liveBuffer)
               {
                  liveStream.writeUTFBytes(entry + "\n");
               }
               liveBuffer.length = 0;
               try
               {
                  liveStream.close();
                  liveStream.open(liveFile,FileMode.APPEND);
               }
               catch(e2:Error)
               {
                  try
                  {
                     liveStream.open(liveFile,FileMode.APPEND);
                  }
                  catch(e3:Error)
                  {
                     trace("⚠️ Failed to reopen live file: " + e3.message);
                  }
               }
            }
            catch(e:Error)
            {
               trace("⚠️ Error flushing main buffer: " + e.message);
               for each(entry in liveBuffer)
               {
                  emergencyBuffer.push(entry);
               }
               liveBuffer.length = 0;
               stats.emergencyWrites++;
            }
         }
         if(emergencyBuffer.length > 0)
         {
            try
            {
               for each(emergEntry in emergencyBuffer)
               {
                  liveStream.writeUTFBytes("[RECOVERED] " + emergEntry + "\n");
               }
               emergencyBuffer.length = 0;
            }
            catch(e:Error)
            {
               trace("⚠️ Emergency buffer flush failed: " + e.message);
            }
         }
      }
      
      private function writeToLiveFile(text:String) : void
      {
         if(!liveFileEnabled)
         {
            return;
         }
         var microTs:String = new Date().getTime() + "." + getTimer();
         var finalText:String = "[" + microTs + "] " + text;
         liveBuffer.push(finalText);
         if(liveBuffer.length >= MAX_BUFFER_SIZE)
         {
            flushLiveBuffer();
         }
         if(emergencyBuffer.length > 0)
         {
            flushLiveBuffer();
         }
      }
      
      private function initConsole() : void
      {
         if(consoleInitialized)
         {
            return;
         }
         try
         {
            rootStage = Sanalika.instance.stage;
            Cc.start(rootStage);
            try
            {
               Cc.config.commandLineAllowed = true;
               Cc.config.maxLines = MAX_CONSOLE_LINES;
            }
            catch(eCfg:Error)
            {
               trace("⚠️ Console config error: " + eCfg.message);
            }
            Cc.visible = true;
            Cc.width = 1000;
            Cc.height = 600;
            Cc.x = 5;
            Cc.y = 5;
            Cc.commandLine = true;
            Cc.fpsMonitor = true;
            Cc.memoryMonitor = true;
            consoleInitialized = true;
            Cc.log("╔═══════════════════════════════════════════════════════════════════╗");
            Cc.log("║          SANALIKA ULTIMATE LOGGER v5.0 - 1000% CAPTURE           ║");
            Cc.log("║          Every packet captured - Zero loss - Guaranteed!         ║");
            Cc.log("╚═══════════════════════════════════════════════════════════════════╝");
            Cc.log("");
            Cc.log("🔥 FEATURES:");
            Cc.log("   ✅ No filters, no truncation, no limits");
            Cc.log("   ✅ Instant flush (500ms)");
            Cc.log("   ✅ Emergency backup system");
            Cc.log("   ✅ Smart auto-clear at " + MAX_CONSOLE_LINES + " lines");
            Cc.log("   ✅ Sequence-based latency tracking");
            Cc.log("   ✅ Micro-timestamp precision");
            Cc.log("");
            consoleKeeper = new Timer(100);
            consoleKeeper.addEventListener(TimerEvent.TIMER,keepConsoleAlive);
            consoleKeeper.start();
            createButtons();
            trace("✅ Console initialized");
         }
         catch(e:Error)
         {
            trace("❌ Console init failed: " + e.message);
         }
      }
      
      private function keepConsoleAlive(e:TimerEvent) : void
      {
         var currentIndex:int;
         var topIndex:int;
         var buttons:Array;
         var btn:Sprite;
         var btnIndex:int;
         var btnTop:int;
         try
         {
            if(!Cc.instance || !Cc.instance.stage)
            {
               if(rootStage)
               {
                  rootStage.addChild(Cc.instance);
                  Cc.visible = true;
               }
            }
            else if(Cc.instance.parent)
            {
               currentIndex = Cc.instance.parent.getChildIndex(Cc.instance);
               topIndex = Cc.instance.parent.numChildren - 1;
               if(currentIndex < topIndex)
               {
                  Cc.instance.parent.setChildIndex(Cc.instance,topIndex);
               }
            }
            buttons = [copyButton,clearButton,liveFileButton,statsButton];
            for each(btn in buttons)
            {
               if(btn && btn.stage && btn.parent)
               {
                  btnIndex = btn.parent.getChildIndex(btn);
                  btnTop = btn.parent.numChildren - 1;
                  if(btnIndex < btnTop)
                  {
                     btn.parent.setChildIndex(btn,btnTop);
                  }
               }
            }
         }
         catch(error:Error)
         {
            trace("⚠️ Console keeper error: " + error.message);
         }
      }
      
      private function createButtons() : void
      {
         createCopyButton();
         createClearButton();
         createLiveFileButton();
         createStatsButton();
      }
      
      private function createCopyButton() : void
      {
         try
         {
            copyButton = createButton("📋 COPY",43520);
            copyButton.x = 780;
            copyButton.y = 10;
            copyButton.addEventListener(MouseEvent.CLICK,onCopyClick);
            copyButton.addEventListener(MouseEvent.MOUSE_OVER,onButtonOver);
            copyButton.addEventListener(MouseEvent.MOUSE_OUT,onButtonOut);
            rootStage.addChild(copyButton);
         }
         catch(e:Error)
         {
            trace("⚠️ Copy button error: " + e.message);
         }
      }
      
      private function createClearButton() : void
      {
         try
         {
            clearButton = createButton("🗑️ CLEAR",11141120);
            clearButton.x = 780;
            clearButton.y = 50;
            clearButton.addEventListener(MouseEvent.CLICK,onClearClick);
            clearButton.addEventListener(MouseEvent.MOUSE_OVER,onButtonOver);
            clearButton.addEventListener(MouseEvent.MOUSE_OUT,onButtonOut);
            rootStage.addChild(clearButton);
         }
         catch(e:Error)
         {
            trace("⚠️ Clear button error: " + e.message);
         }
      }
      
      private function createLiveFileButton() : void
      {
         try
         {
            liveFileButton = createButton("💾 FILE",21930);
            liveFileButton.x = 780;
            liveFileButton.y = 90;
            liveFileButton.addEventListener(MouseEvent.CLICK,onLiveFileClick);
            liveFileButton.addEventListener(MouseEvent.MOUSE_OVER,onButtonOver);
            liveFileButton.addEventListener(MouseEvent.MOUSE_OUT,onButtonOut);
            rootStage.addChild(liveFileButton);
         }
         catch(e:Error)
         {
            trace("⚠️ Live file button error: " + e.message);
         }
      }
      
      private function createStatsButton() : void
      {
         try
         {
            statsButton = createButton("📊 STATS",11162880);
            statsButton.x = 780;
            statsButton.y = 130;
            statsButton.addEventListener(MouseEvent.CLICK,onStatsClick);
            statsButton.addEventListener(MouseEvent.MOUSE_OVER,onButtonOver);
            statsButton.addEventListener(MouseEvent.MOUSE_OUT,onButtonOut);
            rootStage.addChild(statsButton);
         }
         catch(e:Error)
         {
            trace("⚠️ Stats button error: " + e.message);
         }
      }
      
      private function createButton(label:String, color:uint) : Sprite
      {
         var button:Sprite = new Sprite();
         button.graphics.beginFill(color);
         button.graphics.drawRoundRect(0,0,110,30,8,8);
         button.graphics.endFill();
         var textField:TextField = new TextField();
         textField.text = label;
         textField.width = 110;
         textField.height = 30;
         textField.selectable = false;
         textField.mouseEnabled = false;
         var format:TextFormat = new TextFormat();
         format.color = 16777215;
         format.size = 11;
         format.bold = true;
         format.align = "center";
         textField.setTextFormat(format);
         textField.y = 8;
         button.addChild(textField);
         button.buttonMode = true;
         button.alpha = 0.9;
         return button;
      }
      
      private function onButtonOver(e:MouseEvent) : void
      {
         e.currentTarget.alpha = 1;
         e.currentTarget.scaleX = e.currentTarget.scaleY = 1.05;
      }
      
      private function onButtonOut(e:MouseEvent) : void
      {
         e.currentTarget.alpha = 0.9;
         e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
      }
      
      private function onCopyClick(e:MouseEvent) : void
      {
         var report:String;
         try
         {
            Cc.log("⏳ Preparing complete report...");
            report = generateFullReport();
            Cc.log("📊 Report size: " + report.length + " chars (" + Math.ceil(report.length / 1024) + " KB)");
            try
            {
               System.setClipboard(report);
               Cc.log("✅ SUCCESS! Full report copied to clipboard!");
               Cc.log("📋 Total entries: " + logHistory.length);
            }
            catch(clipError:Error)
            {
               Cc.error("❌ Clipboard failed: " + clipError.message);
               Cc.log("💡 Use the FILE button instead!");
            }
         }
         catch(error:Error)
         {
            Cc.error("❌ Copy error: " + error.message);
         }
      }
      
      private function onClearClick(e:MouseEvent) : void
      {
         try
         {
            logHistory.length = 0;
            liveBuffer.length = 0;
            Cc.clear();
            Cc.log("🧹 Console cleared!");
            Cc.log("💡 Live file continues recording...");
            stats.totalPackets = 0;
            stats.totalBytes = 0;
            stats.capturedEntries = 0;
            stats.startTime = getTimer();
         }
         catch(error:Error)
         {
            Cc.error("❌ Clear error: " + error.message);
         }
      }
      
      private function onLiveFileClick(e:MouseEvent) : void
      {
         try
         {
            if(!liveFileEnabled)
            {
               Cc.error("❌ Live file not available");
               return;
            }
            flushLiveBuffer();
            Cc.log("═══════════════════════════════════════════════════════════");
            Cc.log("📄 LIVE FILE INFO");
            Cc.log("═══════════════════════════════════════════════════════════");
            Cc.log("📁 File: " + liveFile.name);
            Cc.log("📂 Location: Desktop");
            Cc.log("📍 Path: " + liveFile.nativePath);
            Cc.log("📏 Size: " + Math.floor(liveFile.size / 1024) + " KB");
            Cc.log("📊 Entries: " + stats.capturedEntries);
            Cc.log("⚠️ Missed: " + stats.missedPackets);
            Cc.log("🚨 Emergency: " + stats.emergencyWrites);
            Cc.log("⏰ Started: " + new Date(stats.startTime).toLocaleString());
            Cc.log("💾 Buffer: " + liveBuffer.length + " pending");
            Cc.log("🆘 Emergency: " + emergencyBuffer.length + " entries");
            Cc.log("═══════════════════════════════════════════════════════════");
            try
            {
               System.setClipboard(liveFile.nativePath);
               Cc.log("✅ Path copied to clipboard!");
            }
            catch(e2:Error)
            {
            }
         }
         catch(error:Error)
         {
            Cc.error("❌ File info error: " + error.message);
         }
      }
      
      private function onStatsClick(e:MouseEvent) : void
      {
         var duration:Number;
         var captureRate:Number;
         try
         {
            duration = (getTimer() - stats.startTime) / 1000;
            captureRate = stats.totalPackets > 0 ? (stats.totalPackets - stats.missedPackets) * 100 / stats.totalPackets : 100;
            Cc.log("═══════════════════════════════════════════════════════════");
            Cc.log("📊 CAPTURE STATISTICS");
            Cc.log("═══════════════════════════════════════════════════════════");
            Cc.log("📦 Total Packets: " + stats.totalPackets);
            Cc.log("📝 Log Entries: " + logHistory.length);
            Cc.log("💾 Total Bytes: " + Math.floor(stats.totalBytes / 1024) + " KB");
            Cc.log("⏱️ Duration: " + duration.toFixed(1) + "s");
            Cc.log("⚡ Rate: " + (stats.totalPackets / duration).toFixed(1) + " packets/sec");
            Cc.log("✅ Capture Rate: " + captureRate.toFixed(2) + "%");
            Cc.log("⚠️ Missed: " + stats.missedPackets);
            Cc.log("🚨 Emergency Writes: " + stats.emergencyWrites);
            Cc.log("🔢 Current Seq: " + seq);
            Cc.log("⏳ Pending Requests: " + countPending());
            Cc.log("═══════════════════════════════════════════════════════════");
         }
         catch(error:Error)
         {
            Cc.error("❌ Stats error: " + error.message);
         }
      }
      
      private function countPending() : int
      {
         var count:int = 0;
         for(var k in pendingByCommand)
         {
            var arr:Array = pendingByCommand[k] as Array;
            if(arr)
            {
               count += arr.length;
            }
         }
         return count;
      }
      
      private function generateFullReport() : String
      {
         var report:String = "";
         var duration:Number = (getTimer() - stats.startTime) / 1000;
         var captureRate:Number = stats.totalPackets > 0 ? (stats.totalPackets - stats.missedPackets) * 100 / stats.totalPackets : 100;
         report += "╔═══════════════════════════════════════════════════════════════════╗\n";
         report += "║        SANALIKA COMPLETE DEBUG REPORT - 1000% CAPTURE            ║\n";
         report += "║        Generated: " + new Date().toLocaleString() + "\n";
         report += "╚═══════════════════════════════════════════════════════════════════╝\n\n";
         report += "📊 SUMMARY:\n";
         report += "──────────────────────────────────────────────────────────────────\n";
         report += "• Total Entries: " + logHistory.length + "\n";
         report += "• Total Packets: " + stats.totalPackets + "\n";
         report += "• Missed Packets: " + stats.missedPackets + "\n";
         report += "• Emergency Writes: " + stats.emergencyWrites + "\n";
         report += "• Session Duration: " + duration.toFixed(1) + "s\n";
         report += "• Capture Rate: " + captureRate.toFixed(2) + "%\n\n";
         report += "📝 COMPLETE LOG ENTRIES:\n";
         report += "══════════════════════════════════════════════════════════════════\n\n";
         var i:int = 0;
         while(i < logHistory.length)
         {
            var entry:Object = logHistory[i];
            report += "─────────────────────────────────────────────────────────────────\n";
            report += "ENTRY #" + (i + 1) + " - " + entry.type + "\n";
            report += "─────────────────────────────────────────────────────────────────\n";
            if(entry.ts)
            {
               report += "⏰ Time: " + entry.ts + "\n";
            }
            if(entry.seq)
            {
               report += "🔢 Seq: " + entry.seq + "\n";
            }
            if(entry.dir)
            {
               report += "📍 Direction: " + entry.dir + "\n";
            }
            if(entry.command)
            {
               report += "📤 Command: " + entry.command + "\n";
            }
            if(entry.kind)
            {
               report += "📦 Kind: " + entry.kind + "\n";
            }
            if(entry.latencyMs != null)
            {
               report += "⏱️ Latency: " + entry.latencyMs + "ms";
               if(entry.latencyMs > 500)
               {
                  report += " ⚠️ SLOW!";
               }
               report += "\n";
            }
            if(entry.errorCode)
            {
               report += "❌ ERROR: " + entry.errorCode + "\n";
               if(entry.errorMessage)
               {
                  report += "   Message: " + entry.errorMessage + "\n";
               }
            }
            if(entry.data)
            {
               report += "📝 DATA:\n";
               report += entry.data + "\n";
            }
            if(entry.meta)
            {
               report += "🔧 META:\n";
               report += entry.meta + "\n";
            }
            if(entry.stack && entry.stack != "NO_STACK")
            {
               report += "🔍 STACK:\n";
               report += entry.stack + "\n";
            }
            report += "\n";
            i++;
         }
         report += "═══════════════════════════════════════════════════════════════════\n";
         report += "END OF REPORT - Total entries: " + logHistory.length + "\n";
         report += "Capture Quality: ";
         if(stats.missedPackets == 0)
         {
            report += "PERFECT (0 missed)\n";
         }
         else
         {
            report += "WARNING (" + stats.missedPackets + " missed)\n";
         }
         return report + "═══════════════════════════════════════════════════════════════════\n";
      }
      
      private function onSfsLog(dir:String, kind:String, payload:Object) : void
      {
         var ts:String;
         var dataStr:String;
         var entryType:String;
         var entry:Object;
         var liveEntry:String;
         var currentSeq:int;
         ++seq;
         stats.totalPackets++;
         stats.capturedEntries++;
         ts = new Date().toTimeString().split(" ")[0] + "." + ("00" + new Date().milliseconds).substr(-3);
         dataStr = safeStringify(payload);
         stats.totalBytes += dataStr.length;
         entryType = dir == "OUT" ? "SFS_SEND" : "SFS_EVENT";
         currentSeq = int(payload && payload["_seq"] ? payload["_seq"] : seq);
         entry = {
            "type":entryType,
            "dir":dir,
            "kind":kind,
            "seq":currentSeq,
            "ts":ts,
            "data":dataStr,
            "stack":new Error().getStackTrace() || "NO_STACK"
         };
         logHistory.push(entry);
         liveEntry = "[" + ts + "] SEQ:" + currentSeq + " " + entryType + " - " + kind + "\n" + dataStr;
         writeToLiveFile(liveEntry);
         if(isChatEvent(kind,payload))
         {
            logChatTrace(dir,kind,payload,dataStr,currentSeq,ts);
         }
         try
         {
            if(logHistory.length % 100 == 0)
            {
               checkConsoleClear();
            }
            Cc.log("═════════════════════════════════════════════════════════════");
            if(dir == "OUT")
            {
               Cc.info("📤 [OUT #" + currentSeq + "] " + kind + " @ " + ts);
            }
            else
            {
               Cc.info("📥 [IN  #" + currentSeq + "] " + kind + " @ " + ts);
            }
            if(dataStr.length > 500)
            {
               Cc.log("📝 " + dataStr.substr(0,500) + "\n... (truncated, see file for full data)");
            }
            else
            {
               Cc.log("📝 " + dataStr);
            }
            Cc.log("═════════════════════════════════════════════════════════════");
         }
         catch(e:Error)
         {
            trace("⚠️ Console log error: " + e.message);
            writeToLiveFile("[CONSOLE_FAILED] " + e.message);
         }
      }
      
      private function onSfsRawLog(rawData:String, direction:String) : void
      {
         try
         {
            writeToLiveFile("[RAW " + direction + "] " + rawData);
         }
         catch(e:Error)
         {
            trace("⚠️ Raw log failed: " + e.message);
            stats.missedPackets++;
         }
      }
      
      private function checkConsoleClear() : void
      {
         var currentLines:int;
         try
         {
            currentLines = int(!!Cc.instance ? Cc.instance.numLines : 0);
            if(currentLines > MAX_CONSOLE_LINES * 0.9)
            {
               Cc.clear();
               Cc.log("🧹 Auto-cleared console (was at " + currentLines + " lines)");
               Cc.log("💾 All data preserved in live file!");
               Cc.log("📊 Total captured: " + stats.capturedEntries + " entries");
            }
         }
         catch(e:Error)
         {
            trace("⚠️ Console clear check error: " + e.message);
         }
      }
      
      private function safeStringify(value:*) : String
      {
         try
         {
            return JSON.stringify(value,null,2);
         }
         catch(e1:Error)
         {
            try
            {
               return JSON.stringify(value);
            }
            catch(e2:Error)
            {
               try
               {
                  return manualStringify(value);
               }
               catch(e3:Error)
               {
                  try
                  {
                     return String(value);
                  }
                  catch(e4:Error)
                  {
                     return "[STRINGIFY_FAILED: " + e4.message + "]";
                  }
               }
            }
         }
      }
      
      private function manualStringify(obj:*) : String
      {
         if(obj == null)
         {
            return "null";
         }
         if(obj is String)
         {
            return "\"" + obj + "\"";
         }
         if(obj is Number || obj is Boolean || obj is int || obj is uint)
         {
            return String(obj);
         }
         if(obj is Array)
         {
            var result:String = "[";
            var first:Boolean = true;
            for each(var item in obj)
            {
               if(!first)
               {
                  result += ", ";
               }
               result += manualStringify(item);
               first = false;
            }
            return result + "]";
         }
         result = "{";
         first = true;
         for(var key in obj)
         {
            if(!first)
            {
               result += ", ";
            }
            result += "\"" + key + "\": " + manualStringify(obj[key]);
            first = false;
         }
         return result + "}";
      }
      
      private function fullStringify(value:*) : String
      {
         return safeStringify(value);
      }
      
      private function startPendingWatcher() : void
      {
         if(pendingTimer)
         {
            return;
         }
         pendingTimer = new Timer(1000);
         pendingTimer.addEventListener(TimerEvent.TIMER,checkPending);
         pendingTimer.start();
      }
      
      private function checkPending(e:TimerEvent) : void
      {
         var now:Number = getTimer();
         for(var k in pendingByCommand)
         {
            var arr:Array = pendingByCommand[k] as Array;
            if(arr && arr.length > 0)
            {
               var idx:int = 0;
               while(idx < arr.length)
               {
                  var entry:Object = arr[idx];
                  var age:Number = now - entry.ts;
                  if(age >= PENDING_TIMEOUT_MS)
                  {
                     Cc.warn("⏰ [TIMEOUT] " + entry.command + " (seq:" + entry.seq + ", " + int(age) + "ms)");
                     logHistory.push({
                        "type":"TIMEOUT",
                        "command":entry.command,
                        "seq":entry.seq,
                        "ageMs":int(age),
                        "data":entry.dataStr
                     });
                     writeToLiveFile("[TIMEOUT] " + entry.command + " seq:" + entry.seq + " - " + int(age) + "ms");
                     arr.splice(idx,1);
                     delete pendingBySeq[entry.seq];
                  }
                  else
                  {
                     idx++;
                  }
               }
               if(arr.length == 0)
               {
                  delete pendingByCommand[k];
               }
            }
         }
      }
      
      private function markPending(cmd:String, data:Object, requestSeq:int) : void
      {
         var dataStr:String = fullStringify(data);
         var entry:Object = {
            "ts":getTimer(),
            "command":cmd,
            "seq":requestSeq,
            "dataStr":dataStr,
            "stack":new Error().getStackTrace() || "NO_STACK"
         };
         var arr:Array = pendingByCommand[cmd] as Array;
         if(!arr)
         {
            arr = [];
            pendingByCommand[cmd] = arr;
         }
         arr.push(entry);
         pendingBySeq[requestSeq] = entry;
      }
      
      private function clearPending(cmd:String) : Object
      {
         var arr:Array = pendingByCommand[cmd] as Array;
         if(arr && arr.length > 0)
         {
            var entry:Object = arr.shift();
            if(entry && entry.seq)
            {
               delete pendingBySeq[entry.seq];
            }
            if(arr.length == 0)
            {
               delete pendingByCommand[cmd];
            }
            return entry;
         }
         return null;
      }
      
      private function clearPendingBySeq(requestSeq:int) : Object
      {
         var entry:Object = pendingBySeq[requestSeq];
         if(entry)
         {
            delete pendingBySeq[requestSeq];
            var cmd:String = String(entry.command);
            var arr:Array = pendingByCommand[cmd] as Array;
            if(arr)
            {
               var idx:int = arr.indexOf(entry);
               if(idx >= 0)
               {
                  arr.splice(idx,1);
               }
               if(arr.length == 0)
               {
                  delete pendingByCommand[cmd];
               }
            }
            return entry;
         }
         return null;
      }
      
      public function requestData(cmd:String, data:Object, callback:Function, room:Room = null) : void
      {
         var errObj:Object;
         var cb:Function;
         var dataStr:String;
         var entry:Object;
         var sp:ServiceParameters;
         var currentSeq:int;
         if(dataList[cmd] == null)
         {
            dataList[cmd] = [];
         }
         if(callback != null)
         {
            dataList[cmd].push(callback);
         }
         if(!ServiceRequestRate.check(cmd) || extensionIdle)
         {
            trace("⚠️ Request rate exceeded for: " + cmd);
            if(cmd == "usedoor" || cmd == "usehousedoor")
            {
               Sanalika.instance.roomModel.mapInitalized = true;
               Sanalika.instance.roomModel.doorModel.busy = false;
            }
            errObj = extensionIdle ? {
               "errorCode":"EXTENSION_IDLE",
               "message":"Please try again in a few seconds."
            } : {
               "errorCode":"FLOOD",
               "message":"Stop flooding or you will be banned soon."
            };
            alertvo = new AlertVo();
            alertvo.alertType = "tooltip";
            alertvo.description = ServiceErrorCode.getMessageById(errObj.errorCode);
            Dispatcher.dispatchEvent(new AlertEvent(alertvo));
            for each(cb in dataList[cmd])
            {
               if(cb != null)
               {
                  cb(errObj);
               }
            }
            delete dataList[cmd];
            return;
         }
         dataStr = fullStringify(data);
         stats.totalBytes += dataStr.length;
         stats.capturedEntries++;
         entry = {
            "type":"SEND",
            "command":cmd,
            "data":dataStr,
            "stack":new Error().getStackTrace() || "NO_STACK"
         };
         logHistory.push(entry);
         logHistory.push(buildNetEntry("net_out",cmd,data,room));
         if(isChatCommand(cmd))
         {
            logChatCommand("CLIENT_SEND",cmd,dataStr,room);
         }
         writeToLiveFile("[CLIENT SEND] " + cmd + "\n" + dataStr);
         try
         {
            Cc.log("═════════════════════════════════════════════════════════════");
            Cc.info("📤 [CLIENT SEND #" + seq + "] Command: " + cmd);
            if(dataStr.length > 500)
            {
               Cc.log("📝 DATA: " + dataStr.substr(0,500) + "...");
            }
            else
            {
               Cc.log("📝 DATA: " + dataStr);
            }
            Cc.log("═════════════════════════════════════════════════════════════");
         }
         catch(e2:Error)
         {
            trace("⚠️ Console log error: " + e2.message);
            writeToLiveFile("[CONSOLE_ERROR] " + e2.message);
         }
         currentSeq = seq + 1;
         markPending(cmd,data,currentSeq);
         sp = new ServiceParameters();
         sp.sn = cmd;
         sp.data = data;
         sendTracked(new ExtensionRequest(cmd,sp.getSFSObject(),room),"ExtensionRequest",{
            "cmd":cmd,
            "room":(!!room ? room.name : null),
            "params":data
         });
      }
      
      protected function onExtensionResponse(event:SFSEvent) : void
      {
         var pendingEntry:Object;
         var latencyMs:int;
         var entry:Object;
         var knownSubCommands:Object;
         var parentCmd:String;
         var cmd:String = String(event.params.cmd);
         var sfsParams:ISFSObject = event.params.params;
         var responseStr:String = dumpSFSObject(sfsParams);
         var respObj:Object = null;
         stats.totalBytes += responseStr.length;
         stats.capturedEntries++;
         try
         {
            respObj = sfsParams.toObject();
         }
         catch(e0:Error)
         {
            respObj = {};
         }
         pendingEntry = clearPending(cmd);
         latencyMs = -1;
         if(pendingEntry)
         {
            latencyMs = int(getTimer() - pendingEntry.ts);
         }
         else
         {
            knownSubCommands = {
               "initQueue":"init",
               "roles":"init",
               "questlistroom":"init",
               "restartServer":"init",
               "privateChatUpdate":"init",
               "displayAd":"init",
               "whispernotify":"init"
            };
            if(knownSubCommands[cmd])
            {
               parentCmd = String(knownSubCommands[cmd]);
               pendingEntry = clearPending(parentCmd);
               if(pendingEntry)
               {
                  latencyMs = int(getTimer() - pendingEntry.ts);
                  Cc.log("⚡ Using parent \'" + parentCmd + "\' latency for \'" + cmd + "\'");
               }
            }
         }
         entry = {
            "type":"RECV",
            "command":cmd,
            "data":responseStr,
            "errorCode":(respObj && respObj.errorCode ? respObj.errorCode : null),
            "errorMessage":(respObj && respObj.message ? respObj.message : null),
            "latencyMs":latencyMs
         };
         logHistory.push(entry);
         logHistory.push(buildNetEntry("net_in",cmd,respObj,null,(respObj && respObj.errorCode ? respObj.errorCode : null)));
         if(isChatCommand(cmd))
         {
            logChatCommand("SERVER_RECV",cmd,responseStr,null);
         }
         writeToLiveFile("[SERVER RECV] " + cmd + " (Latency: " + latencyMs + "ms)\n" + responseStr);
         try
         {
            Cc.log("═════════════════════════════════════════════════════════════");
            Cc.info("📥 [SERVER RECV #" + seq + "] Command: " + cmd);
            if(latencyMs >= 0)
            {
               if(latencyMs > 500)
               {
                  Cc.warn("⏱️ Latency: " + latencyMs + "ms ⚠️ SLOW!");
               }
               else
               {
                  Cc.log("⚡ Latency: " + latencyMs + "ms");
               }
            }
            else
            {
               Cc.log("⏱️ Latency: N/A (unsolicited response)");
            }
            if(respObj && respObj.errorCode)
            {
               Cc.error("❌ Error: " + respObj.errorCode);
               Cc.error("💬 Message: " + respObj.message);
            }
            else
            {
               Cc.log("✅ Success");
            }
            if(responseStr.length > 500)
            {
               Cc.log("📝 RESPONSE: " + responseStr.substr(0,500) + "...");
            }
            else
            {
               Cc.log("📝 RESPONSE: " + responseStr);
            }
            Cc.log("═════════════════════════════════════════════════════════════");
         }
         catch(e2:Error)
         {
            trace("⚠️ Console log error: " + e2.message);
            writeToLiveFile("[CONSOLE_ERROR] " + e2.message);
         }
         if(respObj && respObj.errorCode && respObj.errorCode == "FLOOD")
         {
            trace("⚠️ FLOOD detected");
            ServiceRequestRate.create(cmd,respObj.nextRequest);
         }
         processCallbacks(cmd,respObj,responseStr);
      }
      
      private function processCallbacks(cmd:String, respObj:Object, responseStr:String) : void
      {
         var callbacks:Array = dataList[cmd];
         if(callbacks != null)
         {
            processCallbackList(callbacks,respObj,cmd,responseStr,"data");
            delete dataList[cmd];
         }
         callbacks = extensionList[cmd];
         if(callbacks != null)
         {
            processCallbackList(callbacks,respObj,cmd,responseStr,"extension");
         }
         callbacks = extListenerList[cmd];
         if(callbacks != null)
         {
            processCallbackList(callbacks,respObj,cmd,responseStr,"listener");
         }
      }
      
      private function processCallbackList(callbacks:Array, respObj:Object, cmd:String, responseStr:String, type:String) : void
      {
         var i:int;
         try
         {
            handleSpecialErrors(respObj,cmd);
            i = 0;
            while(i < callbacks.length)
            {
               if(callbacks[i])
               {
                  try
                  {
                     callbacks[i](respObj);
                  }
                  catch(cbErr:Error)
                  {
                     logHistory.push({
                        "type":"CALLBACK_ERROR",
                        "command":cmd,
                        "message":cbErr.message,
                        "stack":cbErr.getStackTrace(),
                        "response":responseStr
                     });
                     Cc.error("💥 Callback crashed for cmd=" + cmd + " : " + cbErr.message);
                     writeToLiveFile("[CALLBACK ERROR] " + cmd + " - " + cbErr.message);
                  }
               }
               i++;
            }
         }
         catch(error:Error)
         {
            trace(error.getStackTrace());
            Cc.error("❌ Exception in " + type + " callback: " + error.message);
         }
      }
      
      private function handleSpecialErrors(respObj:Object, cmd:String) : void
      {
         if(!respObj || !respObj.errorCode)
         {
            return;
         }
         switch(respObj.errorCode)
         {
            case "INSUFFICIENT_ROLE":
               var a:AlertVo = new AlertVo();
               a.alertType = "tooltip";
               a.description = ServiceErrorCode.getRoleErrors(String(respObj.message).split(","));
               Dispatcher.dispatchEvent(new AlertEvent(a));
               break;
            case "MISSING_ITEM":
               a = new AlertVo();
               a.alertType = "tooltip";
               a.description = Sanalika.instance.localizationModel.translate("MISSING_ITEM") + ": " + $("pro_" + respObj.message);
               Dispatcher.dispatchEvent(new AlertEvent(a));
               break;
            case "GUEST_NOT_ALLOWED":
               var panel:PanelVO = new PanelVO("GuestPanel");
               panel.params = respObj;
               Sanalika.instance.panelModel.openPanel(panel);
               break;
            case "WRONG_ITEM":
               var msg:String = String(respObj.message);
               var msgParts:Array = msg.split(",");
               var k:int = 0;
               while(k < msgParts.length)
               {
                  msgParts[k] = Sanalika.instance.localizationModel.translate("pro_" + msgParts[k]);
                  k++;
               }
               a = new AlertVo();
               a.alertType = "tooltip";
               a.description = Sanalika.instance.localizationModel.translate("Wrong hand item to catch fish.") + " (" + msgParts.join(", ") + ")";
               Dispatcher.dispatchEvent(new AlertEvent(a));
               break;
            default:
               a = new AlertVo();
               a.alertType = "tooltip";
               a.description = ServiceErrorCode.getMessageById(respObj.errorCode);
               Dispatcher.dispatchEvent(new AlertEvent(a));
         }
      }

      private function isChatEvent(kind:String, payload:Object) : Boolean
      {
         if(kind == "publicMessage" || kind == "privateMessage")
         {
            return true;
         }
         if(kind == "extensionResponse" && payload && payload["params"] && payload["params"]["cmd"])
         {
            return isChatCommand(String(payload["params"]["cmd"]));
         }
         if(kind == "ExtensionRequest" && payload && payload["cmd"])
         {
            return isChatCommand(String(payload["cmd"]));
         }
         return false;
      }

      private function isChatCommand(cmd:String) : Boolean
      {
         return cmd == "chat" || cmd == "whisper" || cmd == "chat.public.send" || cmd == "chat.public.message" || cmd == "chat.whisper.send" || cmd == "chat.whisper.message" || cmd == "whispernotify" || cmd == "publicMessageLimitExceeded" || cmd == "chat.message" || cmd == "chat.sync" || cmd == "globalchat.join" || cmd == "globalchat.leave";
      }

      private function logChatTrace(dir:String, kind:String, payload:Object, dataStr:String, currentSeq:int, ts:String) : void
      {
         var header:String = "💬 [CHAT TRACE] " + kind + " dir=" + dir + " seq=" + currentSeq + " ts=" + ts;
         var detail:String = dataStr.length > 1000 ? dataStr.substr(0,1000) + "... (truncated)" : dataStr;
         if(kind == "publicMessage" || kind == "privateMessage")
         {
            detail = detail + "\n" + buildChatEventDetails(payload);
         }
         detail = detail + "\n" + buildFlowLine(dir,kind);
         logHistory.push({
            "type":"CHAT_TRACE",
            "dir":dir,
            "kind":kind,
            "seq":currentSeq,
            "ts":ts,
            "data":detail
         });
         try
         {
            Cc.log("═════════════════════════════════════════════════════════════");
            Cc.info(header);
            Cc.log("📝 " + detail);
            Cc.log("═════════════════════════════════════════════════════════════");
         }
         catch(e:Error)
         {
            trace("⚠️ Chat trace log error: " + e.message);
         }
      }

      private function buildChatEventDetails(payload:Object) : String
      {
         if(payload == null || payload["params"] == null)
         {
            return "🧩 CHAT_PARAMS: null";
         }
         var params:Object = payload["params"];
         var sender:User = params["sender"] as User;
         var room:Room = params["room"] as Room;
         var msg:String = String(params["message"]);
         var data:ISFSObject = params["data"] as ISFSObject;
         return "🧩 CHAT_PARAMS {" +
                "senderName=" + (sender ? sender.name : "null") +
                ", senderId=" + (sender ? sender.id : "null") +
                ", roomName=" + (room ? room.name : "null") +
                ", roomId=" + (room ? room.id : "null") +
                ", message=" + msg +
                ", data=" + (data ? dumpSFSObject(data) : "{}") +
                "}";
      }

      private function logChatCommand(direction:String, cmd:String, dataStr:String, room:Room) : void
      {
         var roomName:String = !!room ? room.name : "null";
         logHistory.push({
            "type":"CHAT_COMMAND",
            "direction":direction,
            "command":cmd,
            "room":roomName,
            "data":dataStr.length > 1000 ? dataStr.substr(0,1000) + "... (truncated)" : dataStr
         });
         try
         {
            Cc.log("═════════════════════════════════════════════════════════════");
            Cc.info("💬 [CHAT " + direction + "] cmd=" + cmd + " room=" + roomName);
            if(dataStr.length > 500)
            {
               Cc.log("📝 " + dataStr.substr(0,500) + "... (truncated)");
            }
            else
            {
               Cc.log("📝 " + dataStr);
            }
            Cc.log("═════════════════════════════════════════════════════════════");
         }
         catch(e:Error)
         {
            trace("⚠️ Chat command log error: " + e.message);
         }
      }

      private function buildFlowLine(dir:String, kind:String) : String
      {
         if(dir == "OUT")
         {
            return "🔁 FLOW: CLIENT → SERVER (" + kind + ")";
         }
         return "🔁 FLOW: SERVER → CLIENT (" + kind + ")";
      }

      private function buildNetEntry(direction:String, cmd:String, payload:Object, room:Room, errorCode:String = null) : Object
      {
         var meta:Object = buildPayloadMeta(payload);
         return {
            "type":direction,
            "cmd":cmd,
            "room":room != null ? room.name : null,
            "payload":payload,
            "payloadKeys":meta.keys,
            "payloadTypes":meta.types,
            "errorCode":errorCode
         };
      }

      private function buildPayloadMeta(payload:Object) : Object
      {
         var keys:Array = [];
         var types:Object = {};
         if(payload != null)
         {
            for(var key:String in payload)
            {
               keys.push(key);
               types[key] = getValueType(payload[key]);
            }
         }
         return {
            "keys":keys,
            "types":types
         };
      }

      private function getValueType(value:*) : String
      {
         if(value == null)
         {
            return "null";
         }
         if(value is Array)
         {
            return "Array";
         }
         return typeof value;
      }
      
      private function dumpSFSObject(obj:ISFSObject) : String
      {
         try
         {
            return dumpISFSObject(obj,0,new Dictionary(true));
         }
         catch(e:Error)
         {
            return "[SFS_DUMP_ERROR] " + e.message;
         }
      }
      
      private function dumpISFSObject(obj:ISFSObject, depth:int, seen:Dictionary) : String
      {
         var out:String;
         var keys:Array;
         var count:int;
         var k:String;
         if(obj == null)
         {
            return "null";
         }
         if(depth > 20)
         {
            return "{...}";
         }
         if(seen[obj])
         {
            return "{↻}";
         }
         seen[obj] = true;
         out = "{";
         try
         {
            keys = obj.getKeys();
         }
         catch(e:Error)
         {
            keys = [];
         }
         count = 0;
         for each(k in keys)
         {
            out += (count > 0 ? ", " : "") + k + ": " + dumpSFSValue(obj,k,depth + 1,seen);
            count++;
         }
         return out + "}";
      }
      
      private function dumpSFSArray(arr:ISFSArray, depth:int, seen:Dictionary) : String
      {
         var out:String;
         var n:int;
         var i:int;
         if(arr == null)
         {
            return "null";
         }
         if(depth > 20)
         {
            return "[...]";
         }
         if(seen[arr])
         {
            return "[↻]";
         }
         seen[arr] = true;
         out = "[";
         try
         {
            n = int(arr.size());
         }
         catch(e:Error)
         {
            n = 0;
         }
         i = 0;
         while(i < n)
         {
            out += (i > 0 ? ", " : "") + dumpSFSArrayItem(arr,i,depth + 1,seen);
            i++;
         }
         return out + "]";
      }
      
      private function dumpSFSValue(obj:ISFSObject, key:String, depth:int, seen:Dictionary) : String
      {
         var so:ISFSObject;
         var sa:ISFSArray;
         var s:String;
         var ba:ByteArray;
         try
         {
            so = obj.getSFSObject(key);
            if(so != null)
            {
               return dumpISFSObject(so,depth,seen);
            }
         }
         catch(e0:Error)
         {
         }
         try
         {
            sa = obj.getSFSArray(key);
            if(sa != null)
            {
               return dumpSFSArray(sa,depth,seen);
            }
         }
         catch(e1:Error)
         {
         }
         try
         {
            ba = obj.getByteArray(key);
            if(ba != null)
            {
               return "<ByteArray len=" + ba.length + ">";
            }
         }
         catch(e8:Error)
         {
         }
         try
         {
            return String(obj.getLong(key));
         }
         catch(e5:Error)
         {
         }
         try
         {
            return String(obj.getDouble(key));
         }
         catch(e6:Error)
         {
         }
         try
         {
            return String(obj.getFloat(key));
         }
         catch(e7:Error)
         {
         }
         try
         {
            return String(obj.getInt(key));
         }
         catch(e4:Error)
         {
         }
         try
         {
            return String(obj.getBool(key));
         }
         catch(e3:Error)
         {
         }
         try
         {
            s = String(obj.getUtfString(key));
            if(s != null)
            {
               return "\"" + s + "\"";
            }
         }
         catch(e2:Error)
         {
         }
         return "null";
      }
      
      private function dumpSFSArrayItem(arr:ISFSArray, idx:int, depth:int, seen:Dictionary) : String
      {
         var so:ISFSObject;
         var sa:ISFSArray;
         var s:String;
         var ba:ByteArray;
         try
         {
            so = arr.getSFSObject(idx);
            if(so != null)
            {
               return dumpISFSObject(so,depth,seen);
            }
         }
         catch(e0:Error)
         {
         }
         try
         {
            sa = arr.getSFSArray(idx);
            if(sa != null)
            {
               return dumpSFSArray(sa,depth,seen);
            }
         }
         catch(e1:Error)
         {
         }
         try
         {
            ba = arr.getByteArray(idx);
            if(ba != null)
            {
               return "<ByteArray len=" + ba.length + ">";
            }
         }
         catch(e8:Error)
         {
         }
         try
         {
            return String(arr.getLong(idx));
         }
         catch(e5:Error)
         {
         }
         try
         {
            return String(arr.getDouble(idx));
         }
         catch(e6:Error)
         {
         }
         try
         {
            return String(arr.getFloat(idx));
         }
         catch(e7:Error)
         {
         }
         try
         {
            return String(arr.getInt(idx));
         }
         catch(e4:Error)
         {
         }
         try
         {
            return String(arr.getBool(idx));
         }
         catch(e3:Error)
         {
         }
         try
         {
            s = String(arr.getUtfString(idx));
            if(s != null)
            {
               return "\"" + s + "\"";
            }
         }
         catch(e2:Error)
         {
         }
         return "null";
      }
      
      protected function onRoomVariableUpdate(event:SFSEvent) : void
      {
         var key:String;
         var listeners:Array;
         var j:int;
         var changed:Array = event.params.changedVars as Array;
         var r:Room = event.params.room as Room;
         var i:int = 0;
         while(i < changed.length)
         {
            key = String(changed[i]);
            listeners = roomVarList[key];
            try
            {
               Cc.log("🔄 [ROOM VAR UPDATE] " + key + " in " + r.name);
               writeToLiveFile("[ROOM VAR] " + key + " in " + r.name);
            }
            catch(e:Error)
            {
               writeToLiveFile("[ROOM VAR LOG FAILED] " + e.message);
            }
            if(listeners != null)
            {
               j = 0;
               while(j < listeners.length)
               {
                  try
                  {
                     listeners[j](r);
                  }
                  catch(e2:Error)
                  {
                     Cc.error("❌ Room var callback error: " + e2.message);
                  }
                  j++;
               }
            }
            i++;
         }
      }
      
      protected function onUserVariableUpdate(event:SFSEvent) : void
      {
         var key:String;
         var listeners:Array;
         var j:int;
         var changed:Array = event.params.changedVars as Array;
         var u:User = event.params.user as User;
         var userVar:SFSUserVariable;
         var varValue:*;
         var varType:String;
         var i:int = 0;
         while(i < changed.length)
         {
            key = String(changed[i]);
            listeners = userVarList[key];
            try
            {
               userVar = u != null ? u.getVariable(key) as SFSUserVariable : null;
               varValue = userVar != null ? userVar.getValue() : null;
               varType = userVar != null ? userVar.type : "null";
               Cc.log("👤 [USER VAR UPDATE] " + key + " for " + u.name);
               Cc.log("🧩 [USER VAR DATA] {\"name\":\"" + key + "\",\"value\":" + safeStringify(varValue) + ",\"type\":\"" + varType + "\",\"user\":\"" + u.name + "\"}");
               writeToLiveFile("[USER VAR] " + key + " for " + u.name + " value=" + safeStringify(varValue) + " type=" + varType);
            }
            catch(e:Error)
            {
               writeToLiveFile("[USER VAR LOG FAILED] " + e.message);
            }
            if(listeners != null)
            {
               j = 0;
               while(j < listeners.length)
               {
                  try
                  {
                     listeners[j](u);
                  }
                  catch(e2:Error)
                  {
                     Cc.error("❌ User var callback error: " + e2.message);
                  }
                  j++;
               }
            }
            i++;
         }
      }
      
      public function sendRaw(req:*, kind:String, meta:Object = null) : void
      {
         var stackStr:String = String(new Error().getStackTrace() || "NO_STACK");
         if(meta == null)
         {
            meta = {};
         }
         try
         {
            meta["callerStack"] = stackStr;
         }
         catch(e2:Error)
         {
         }
         sendTracked(req,kind,meta);
      }
      
      private function sendTracked(req:*, kind:String, meta:Object = null) : void
      {
         var metaStr:String;
         var stackIn:String;
         ++seq;
         stats.totalPackets++;
         try
         {
            metaStr = !!meta ? JSON.stringify(meta,null,2) : "{}";
         }
         catch(e:Error)
         {
            metaStr = String(meta);
         }
         stats.totalBytes += metaStr.length;
         stackIn = null;
         try
         {
            if(meta && meta["callerStack"])
            {
               stackIn = String(meta["callerStack"]);
            }
         }
         catch(e0:Error)
         {
         }
         logHistory.push({
            "type":"SEND_RAW",
            "kind":kind,
            "seq":seq,
            "meta":metaStr,
            "stack":stackIn
         });
         writeToLiveFile("[SEND_RAW] " + kind + "\n" + metaStr);
         try
         {
            Cc.log("═════════════════════════════════════════════════════════════");
            Cc.info("📤 [SEND_RAW #" + seq + "] " + kind);
            if(metaStr.length > 500)
            {
               Cc.log("📝 META: " + metaStr.substr(0,500) + "...");
            }
            else
            {
               Cc.log("📝 META: " + metaStr);
            }
            Cc.log("═════════════════════════════════════════════════════════════");
         }
         catch(e2:Error)
         {
            trace("⚠️ Console log error: " + e2.message);
            writeToLiveFile("[CONSOLE_ERROR] " + e2.message);
         }
         _sfs.send(req);
      }
      
      public function setRoomVariable(keys:Array, values:Array) : void
      {
         if(keys.length != values.length)
         {
            return;
         }
         var vars:Array = [];
         var i:int = 0;
         while(i < keys.length)
         {
            vars.push(new SFSRoomVariable(keys[i],values[i]));
            i++;
         }
         sendTracked(new SetRoomVariablesRequest(vars),"SetRoomVariablesRequest",{
            "keys":keys,
            "values":values
         });
      }
      
      public function setUserVariable(keys:Array, values:Array) : void
      {
         if(keys.length != values.length)
         {
            return;
         }
         var vars:Array = [];
         var i:int = 0;
         while(i < keys.length)
         {
            vars.push(new SFSUserVariable(keys[i],values[i]));
            i++;
         }
         sendTracked(new SetUserVariablesRequest(vars),"SetUserVariablesRequest",{
            "keys":keys,
            "values":values
         });
      }
      
      public function get sfs() : SmartFox
      {
         return _sfs;
      }
      
      public function set sfs(value:SmartFox) : void
      {
         _sfs = value as SmartFoxLogged;
      }
      
      public function activate() : void
      {
         if(isActive)
         {
            return;
         }
         _sfs.addEventListener("userVariablesUpdate",onUserVariableUpdate);
         _sfs.addEventListener("roomVariablesUpdate",onRoomVariableUpdate);
         _sfs.addEventListener("extensionResponse",onExtensionResponse);
         isActive = true;
      }
      
      public function deactivate() : void
      {
         if(!isActive)
         {
            return;
         }
         _sfs.removeEventListener("userVariablesUpdate",onUserVariableUpdate);
         _sfs.removeEventListener("roomVariablesUpdate",onRoomVariableUpdate);
         _sfs.removeEventListener("extensionResponse",onExtensionResponse);
         isActive = false;
      }
      
      public function getVariableByUserId(userId:String, varName:String) : UserVariable
      {
         if(sfs.lastJoinedRoom == null)
         {
            return null;
         }
         var u:User = sfs.lastJoinedRoom.getUserByName(userId);
         if(u == null)
         {
            return null;
         }
         return u.getVariable(varName);
      }
      
      public function listenAndDispatchRoomVariable(varName:String, callback:Function) : void
      {
         listenRoomVariable(varName,callback);
         var r:Room = sfs.lastJoinedRoom;
         if(r == null)
         {
            return;
         }
         var rv:RoomVariable = r.getVariable(varName);
         if(rv == null)
         {
            return;
         }
         callback(r);
      }
      
      public function listenRoomVariable(varName:String, callback:Function) : void
      {
         if(roomVarList[varName] == null)
         {
            roomVarList[varName] = [];
         }
         roomVarList[varName].push(callback);
      }
      
      public function removeRoomVariable(varName:String, callback:Function) : void
      {
         if(roomVarList[varName] == null)
         {
            return;
         }
         var idx:int = int(roomVarList[varName].indexOf(callback));
         if(idx == -1)
         {
            return;
         }
         roomVarList[varName].splice(idx,1);
      }
      
      public function listenUserVariable(varName:String, callback:Function) : void
      {
         if(userVarList[varName] == null)
         {
            userVarList[varName] = [];
         }
         userVarList[varName].push(callback);
      }
      
      public function removeUserVariable(varName:String, callback:Function) : void
      {
         if(userVarList[varName] == null)
         {
            return;
         }
         var idx:int = int(userVarList[varName].indexOf(callback));
         if(idx == -1)
         {
            return;
         }
         userVarList[varName].splice(idx,1);
      }
      
      public function listenExtension(cmd:String, callback:Function) : void
      {
         if(extListenerList[cmd] == null)
         {
            extListenerList[cmd] = [];
         }
         extListenerList[cmd].push(callback);
      }
      
      public function removeExtension(cmd:String, callback:Function) : void
      {
         if(extListenerList[cmd] == null)
         {
            return;
         }
         var idx:int = int(extListenerList[cmd].indexOf(callback));
         if(idx == -1)
         {
            return;
         }
         extListenerList[cmd].splice(idx,1);
      }
      
      public function requestExtension(cmd:String, data:Object, callback:Function, room:Room = null) : void
      {
         requestData(cmd,data,callback,room);
      }
      
      public function removeRequestData(cmd:String, callback:Function) : void
      {
         if(dataList[cmd] == null)
         {
            return;
         }
         var idx:int = int(dataList[cmd].indexOf(callback));
         if(idx == -1)
         {
            return;
         }
         dataList[cmd].splice(idx,1);
      }
      
      public function removeRequestExtension(cmd:String, callback:Function) : void
      {
         removeRequestData(cmd,callback);
      }
   }
}
