<?xml version="1.0" encoding="UTF-8"?>
<ServerSetup>
    <ServerName>MyGameServer</ServerName>
    <MaxUsers>500</MaxUsers>
    
    <!-- Connection settings -->
    <SocketAddress>127.0.0.1</SocketAddress>
    <SocketPort>9933</SocketPort>
    
    <HttpAddress>127.0.0.1</HttpAddress>
    <HttpPort>8080</HttpPort>
    
    <AdminPort>8000</AdminPort>
    
    <!-- Zones -->
    <Zones>
        <Zone name="marhab">
            <Settings>
                <MaxUsers>200</MaxUsers>
                <MaxUserNameChars>20</MaxUserNameChars>
            </Settings>
            
            <!-- Rooms -->
            <Rooms>
                <Room name="street01" maxUsers="100" isGame="false" isPublic="true">
                    <Extension name="AuthExtension" className="auth.AuthenticationExtension"/>
                </Room>
            </Rooms>
            
            <!-- Extensions -->
            <Extensions>
                <extension name="AuthExtension" 
                          type="class" 
                          className="auth.AuthenticationExtension" 
                          file="extensions/AuthenticationExtension.jar"/>
            </Extensions>
        </Zone>
    </Zones>
</ServerSetup>