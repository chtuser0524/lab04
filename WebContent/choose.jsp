<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<meta charset=utf-8>
</head>
<body>

<p><font size="5"color="#FF0000"><b>上傳要傳真的檔案</b></font></p>

<form name="upload" enctype="multipart/form-data" method="post" action="fileUpload.jsp"> 
<p>上傳檔案： <input type="file" name="file" size="20" maxlength="20" /> </p>
<p> <input type="submit"value="上傳" /> </p>

</form>


</body>
</html>