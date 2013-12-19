package aspects.encyption;
import interactive.Client;
import java.io.IOException;
import joinpoints.connection.ChannelJP;
import org.apache.log4j.Logger;
import baseaspects.connection.CompleteConnectionAspect;
import aspects.encyption.*;

//public static SharedKey sharedKey;

public aspect LoggingInitiatorTime extends CompleteConnectionAspect{
	
	Logger logger = Logger.getLogger(LoggingInitiatorTime.class);
	
	Object around(ChannelJP _channelJp): ConversationBeginOnInitiator(_channelJp)
	{					
		//This code is about how the KMClient can communicate with the KeyManager to get the Key

		KMClient km_client = new KMClient();
		km_client.connectToServer();//Connecting to KeyManager
		System.out.println("Connection to the Key Manager ");
		km_client.sendMessage(new KeyRequest(Client.class.getSimpleName(),"abcdef"));
		System.out.println("Message sent to KM");
		try 
		{
			KeyResponse resp = (KeyResponse) km_client.receiveMessage();
			System.out.println("Message received from KM " + resp);
			km_client.closeSocket();
			if (resp != null) {
				EncryptionAspect.sharedKey = resp.getKey();
				System.out.println("shared key " + EncryptionAspect.sharedKey);
			}
		}	
		catch (IOException e) 
		{
			e.printStackTrace();
			km_client.closeSocket();
		}
	
       	return proceed(_channelJp);
	}
		
}

				

