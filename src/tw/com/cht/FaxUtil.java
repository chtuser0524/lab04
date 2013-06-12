package tw.com.cht;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.rmi.RemoteException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import cht.paas.util.CloudLogger;
import cht.paas.util.LogLevel;

import paas.fax.bean.QueryPackage;
import paas.fax.bean.Result;
import paas.fax.main.FaxRequester;

public class FaxUtil {

	public static String sendFax(String subject, String receiver, String sendType, String sendTime, String senderName, String senderFax) 
	{
		CloudLogger logger = CloudLogger.getLogger();
		logger.setLevel(LogLevel.ALL);
		
		String isvAccount = "367f7deaa1ce47b185a0c91cb6d8f714";
		String isvKey = "n+ABj+1w6e1Ht2A2ziBh0Q==";
		
		try {
			
			logger.info("start");
			
			FaxRequester requester = new FaxRequester();
			
			logger.info("authentication");
			
			// authentication
			Result authResult = requester.authentication(isvAccount, isvKey);
//			System.out.println(String.format("Auth Result: %s, %s", authResult.isSuccess(), authResult.getDescription()));
			logger.info(String.format("Auth Result: %s, %s", authResult.isSuccess(), authResult.getDescription()));
			
			logger.info("upload file");
			
			// 讀取檔案
//			File uploadFile = new File("yourUploadFilePath");
			File uploadFile = new File("../doc/lab4.pdf");
			byte[] filebytes = readBytesFromFile(uploadFile);
			Result uploadResult = requester.uploadFile(filebytes, uploadFile.getName());
//			System.out.println(String.format("Upload Result: %s, %s", uploadResult.isSuccess(), uploadResult.getDescription()));
			logger.info(String.format("Upload Result: %s, %s", uploadResult.isSuccess(), uploadResult.getDescription()));
			
			logger.info("sendTimeFormat");
			
			// 傳送型態
//			SimpleDateFormat sendTimeFormat = new SimpleDateFormat("yyyy-MM-dd-HH-mm");
			SimpleDateFormat sendTimeFormat = new SimpleDateFormat(sendTime);
			
			// 接收者
			List<String> receiverList = new ArrayList<String>();
//			receiverList.add("receiver;faxNo");
			String[] receivers = receiver.split("/");
			for (String rec : receivers)
			{
				receiverList.add(rec);
			}
			
			logger.info("sendFaxEx");
			
			// 發送傳真
			Result sendResult = requester.sendFaxEx(subject, 
													Integer.parseInt(sendType), 
													sendTimeFormat.format(Calendar.getInstance().getTime()),
													receiverList, 
													senderName, 
													senderFax);
//			System.out.println(String.format("SendFax Result: %s, %s", sendResult.isSuccess(), sendResult.getDescription()));
			logger.info(String.format("SendFax Result: %s, %s", sendResult.isSuccess(), sendResult.getDescription()));
			
			logger.info("getFaxDeliveryStatusEx");
			
			// 查詢傳真結果
			requester.authentication(isvAccount, isvKey);
			//String[] queryTels = {"receiver;faxNo"};
			String[] queryTels = (String[])receiverList.toArray();
			QueryPackage queryPackage = requester.getFaxDeliveryStatusEx(sendResult.getMessageId(), queryTels);
			Result queryResult = queryPackage.getQueryResult();
			String result = String.format("Query Result: %s, %s", queryResult.isSuccess(), queryResult.getDescription());
//			System.out.println(result);
			logger.info(result);
			
			return result;

		} catch (RemoteException e) {
			e.printStackTrace();
			
			String error = "Error: " + e.getMessage();
			logger.error(error);

			return error;

		} catch (IOException e) {
			e.printStackTrace();
			
			String error = "Error: " + e.getMessage();
			logger.error(error);

			return error;

		}
		catch (Exception e) {
			e.printStackTrace();
			
			String error = "Error: " + e.getMessage();
			logger.error(error);

			return error;

		}
	}
	
    private static byte[] readBytesFromFile(File file) throws IOException {
        InputStream is = new FileInputStream(file);
    
        // Get the size of the file
        long length = file.length();
    
        if (length > Integer.MAX_VALUE) {
            // File is too large
        }
    
        // Create the byte array to hold the data
        byte[] bytes = new byte[(int)length];
    
        // Read in the bytes
        int offset = 0;
        int numRead = 0;
        while (offset < bytes.length
               && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
            offset += numRead;
        }
    
        // Ensure all the bytes have been read in
        if (offset < bytes.length) {
            throw new IOException("Could not completely read file "+file.getName());
        }
    
        // Close the input stream and return bytes
        is.close();
        return bytes;
    }
	
}
