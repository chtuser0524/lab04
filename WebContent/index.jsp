<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<meta charset=utf-8>
<title>Send FAX</title>
</head>
<body>
<form action="getContent.jsp" method="post">
<table width="100%" border="1">
	<tr width="100%">
		<td width="40%">傳真主旨</td>
		<td><input name="subject" type="text" size="20" maxlength="70" value="測試" /></td>
	</tr>
	<tr>
		<td width="40%">接收者名單(每一組"王先生;0223456789", 若有多組, 則以"/"隔開)</td>
		<td><input name="receiver" type="text" size="200" maxlength="200" value="林先生;0226552869" /></td>
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
		<td><input name="senderName" type="text" size="20" maxlength="30" value="測試者" /></td>
	</tr>
	<tr>
		<td>傳送者傳真電話</td>
		<td><input name="senderFax" type="text" size="20" maxlength="30" value="0223266604" /></td>
	</tr>
</table>
<input type="submit" value="送出" />
</form>
</body>
</html>