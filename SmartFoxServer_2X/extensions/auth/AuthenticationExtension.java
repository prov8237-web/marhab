package auth;

import com.smartfoxserver.v2.extensions.SFSExtension;

public class AuthenticationExtension extends SFSExtension {
    
    @Override
    public void init() {
        trace("=== Authentication Extension Started ===");
        trace("Extension initialized successfully");
        
        // إضافة handlers
        addRequestHandler("login", LoginHandler.class);
        addRequestHandler("register", RegisterHandler.class);
        addRequestHandler("test", TestHandler.class);
    }
    
    @Override
    public void destroy() {
        trace("Extension destroyed");
        super.destroy();
    }
}