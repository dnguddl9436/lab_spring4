<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="../common/commonUIglobal.jsp" flush="false"/>
</head>
<body>
<table class="easyui-datagrid">
    <thead>
        <tr>
            <th data-options="field:'code'">Code</th>
            <th data-options="field:'name'">Name</th>
            <th data-options="field:'price'">Price</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>001</td><td>name1</td><td>2323</td>
        </tr>
        <tr>
            <td>002</td><td>name2</td><td>4612</td>
        </tr>
    </tbody>
</table>
</body>
</html>