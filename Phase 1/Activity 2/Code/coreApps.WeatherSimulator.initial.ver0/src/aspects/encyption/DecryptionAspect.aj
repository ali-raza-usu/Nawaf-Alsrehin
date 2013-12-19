package aspects.encyption;

import java.security.Key;

import joinpoints.communication.ReceiveEventJP;
import joinpoints.communication.SendEventJP;

import org.apache.log4j.Logger;

import utilities.Encoder;
import utilities.Message;
import baseaspects.communication.*;

public aspect DecryptionAspect extends OneWayReceiveAspect
{
	private Logger logger = Logger.getLogger(OneWaySendAspect.class);			
	public Message decryptedMessage;
	Encryption encryption = Encryption.getInstance();
	
	
	Object around (ReceiveEventJP _receiveEventJp): ConversationEnd( _receiveEventJp)
	{
		/*
		 * 1. Decrypt the bytes 
		 * 2. get the MESSAGE
		 * 3. Set the Message
		 */
		//System.out.println("Decryption Ascpet");
		//System.out.println(" number of bytes are " + _receiveEventJp.getBytes().length);
		if(_receiveEventJp.getBytes().length > 0)
			decryptedMessage = encryption.Decrypt(_receiveEventJp.getBytes(), EncryptionAspect.sharedKey.getSharedKey());
		
		//System.out.println(decryptedMessage);
		_receiveEventJp.setBytes(Encoder.encode(decryptedMessage));
		return proceed(_receiveEventJp);
	}
	
}
