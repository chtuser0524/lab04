<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tw.com.cht.FaxUtil" %>
<%@ page import="cht.paas.util.CloudLogger" %>
<%@ page import="cht.paas.util.LogLevel" %>

<%
CloudLogger logger = CloudLogger.getLogger();
logger.setLevel(LogLevel.ALL);

String subject = request.getParameter("subject")==null?"":new String(request.getParameter("subject").getBytes( "ISO-8859-1"), "UTF-8");

String receiver = request.getParameter("receiver")==null?"":new String(request.getParameter("receiver").getBytes( "ISO-8859-1"), "UTF-8");

String sendType = request.getParameter("sendType")==null?"":new String(request.getParameter("sendType").getBytes( "ISO-8859-1"), "UTF-8");

String sendTime = request.getParameter("sendTime")==null?"":request.getParameter("sendTime");

String senderName = request.getParameter("senderName")==null?"":new String(request.getParameter("senderName").getBytes( "ISO-8859-1"), "UTF-8");

String senderFax = request.getParameter("senderFax")==null?"":request.getParameter("senderFax");

String filePath = request.getParameter("filePath")==null?"":request.getParameter("filePath");

String result = FaxUtil.sendFax(subject, receiver, sendType, sendTime, senderName, senderFax, filePath);

logger.info("result: " + result);

out.println("result: " + result);
%>
