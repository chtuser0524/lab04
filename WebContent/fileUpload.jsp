<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>

<%@ page import="cht.paas.util.CloudLogger" %>
<%@ page import="cht.paas.util.LogLevel" %>

<%
CloudLogger logger = CloudLogger.getLogger();
logger.setLevel(LogLevel.ALL);

String filePath = "";
	try
	{
		logger.info("enter file upload.");
		
		// 處理檔案上傳
		
		String saveDirectory = application.getRealPath("/");
	    
	    // Check that we have a file upload request
	    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	    //out.println("isMultipart="+isMultipart+"<br>");
	    
	    // Create a factory for disk-based file items
	    FileItemFactory factory = new DiskFileItemFactory();
	    		
	    // Create a new file upload handler
	    ServletFileUpload upload = new ServletFileUpload(factory);

	    //Create a progress listener
	    ProgressListener progressListener = new ProgressListener(){
	       private long megaBytes = -1;
	       public void update(long pBytesRead, long pContentLength, int pItems) {
	           long mBytes = pBytesRead / 1000000;
	           if (megaBytes == mBytes) {
	               return;
	           }
	           megaBytes = mBytes;
	           System.out.println("We are currently reading item " + pItems);
	           if (pContentLength == -1) {
	               System.out.println("So far, " + pBytesRead + " bytes have been read.");
	           } else {
	               System.out.println("So far, " + pBytesRead + " of " + pContentLength
	                                  + " bytes have been read.");
	           }
	       }
	    };
	    upload.setProgressListener(progressListener);
	    
	    logger.info("start upload.parseRequest(request)");
	    
	    // Parse the request
	    List /* FileItem */ items = upload.parseRequest(request);
	    
	    logger.info("start process uploaded items.");
	    
	    // Process the uploaded items
	    Iterator iter = items.iterator(); 
	    while (iter.hasNext()) {
	        FileItem item = (FileItem) iter.next();

	        if (item.isFormField()) {
	            //// Process a regular form field
	            //processFormField(item);
	            String name = item.getFieldName();
	            String value = item.getString();
	            value = new String(value.getBytes("UTF-8"), "ISO-8859-1");
	            //out.println(name + "=" + value+"<br>");
	        } else {
	            // Process a file upload
	            //processUploadedFile(item);
	            String fieldName = item.getFieldName();
	            String fileName = item.getName();
	            String contentType = item.getContentType();
	            boolean isInMemory = item.isInMemory();
	            long sizeInBytes = item.getSize();
	            //out.println("fieldName="+fieldName+"<br>");
	            //out.println("fileName="+fileName+"<br>");
	            //out.println("contentType="+contentType+"<br>");
	            //out.println("isInMemory="+isInMemory+"<br>");
	            //out.println("sizeInBytes="+sizeInBytes+"<br>");
	            if (fileName != null && !"".equals(fileName)) {
	                fileName= FilenameUtils.getName(fileName);
	                //out.println("fileName saved="+fileName+"<br>");
	                //File uploadedFile = new File(saveDirectory, fileName);
	                File uploadedFile = new File(saveDirectory, "faxfile.pdf");
	                
	                // 儲存檔案位置
	                filePath = saveDirectory + "faxfile.pdf";
	                
	                item.write(uploadedFile);
	                
	                //out.println("fileName saved="+filePath+"<br>");
	                out.println("<font size=\"2\">fileName saved="+filePath+"</font><br>");
	            }            
	        }
	    }
	    
	    // 以上處理檔案上傳
		//out.println("upload done<br>");
	    logger.info("upload done");
	}
	catch (Exception e)
	{
		logger.error("Exception: " + e.getMessage());
	}
    
%>

<html>
<head>
<meta charset=utf-8>
<title>Send FAX Demo</title>
</head>
<body>
<form action="getContent.jsp" method="post">
<table width="100%" border="1">
	<tr width="100%">
		<td colspan="2" >設定傳真資訊</td>
	</tr>
	<tr width="100%">
		<td width="30%">傳真主旨</td>
		<td width="70%"><input name="subject" type="text" size="20" maxlength="70" value="測試"  /></td>
	</tr>
	<tr>
		<td>接收者名單(每一組以"王先生;0223456789"表示, 若有多組, 則以"/"隔開)</td>
		<td><input name="receiver" type="text" size="120" maxlength="200" value="林先生;0223266604" /></td>
	</tr>
	<tr>
		<td>傳送型態(立即或預約, 立即=1 預約=2)</td>
		<td><input name="sendType" type="text" size="1" maxlength="1" value="1" /></td>
	</tr>
	<tr>
		<td>傳送時間(格式：2008-10-02-10-05)</td>
		<td><input name="sendTime" type="text" size="16" maxlength="16" value="2013-06-11-20-50" /></td>
	</tr>
	<tr>
		<td>傳送者姓名</td>
		<td><input name="senderName" type="text" size="20" maxlength="30" value="測試者2" /></td>
	</tr>
	<tr>
		<td>傳送者傳真電話</td>
		<td><input name="senderFax" type="text" size="20" maxlength="30" value="0226552869" /></td>
	</tr>
</table>
<input name="filePath" type="text" hidden="true" value="<%=filePath %>" />
<input type="submit" value="送出" />
</form>
</body>
</html>
