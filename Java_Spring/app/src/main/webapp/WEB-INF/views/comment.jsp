<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
  <head>
    <title>댓글</title>
    <style>
      body {
        margin: 0;
        padding: 0;
        padding-top: 80px;
        background-color: #ececec;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
        height: 100vh;
      }

      .header {
        display: flex;
        position: fixed;
        justify-content: space-between;
        align-items: center;
        top: 0;
        width: 100%;
        background-color: #d6d6d6;
        border-bottom: 1px solid #ddd; 
        padding: 10px 20px;
        box-sizing: border-box; /* border와 padding을 너비에 포함 */
      }

      .header h2 {
        margin: 0;
        padding-left: 20px; 
        text-align: left;
      }
      
      .header-actions {
        display: flex;
        flex-direction: row;
        align-items: center; 
        padding-right: 20px; 
      }
      
      .header-button {
        margin-top: 10px;
        margin-left: 10px; 
        padding: 8px 15px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
      }
      
      /* 회원탈퇴 버튼 */
      .header-button:nth-child(1) { 
        background-color: red;
        color: white;
      }
      
      /* 로그아웃 버튼 */
      .header-button:nth-child(2) { 
        background-color: blue;
        color: white;
      }
      
      .header-button:hover {
        opacity: 0.8; 
      }
      
      .comment-box {
        background-color: #fff;
        padding: 20px;
        border-radius: 5px;
        box-shadow: 0 0 10px rgba(39, 39, 39, 0.1);
        width: 80%;
      }

      .comment-form {
        display: flex; 
        width: 100%; 
        align-items: stretch; /* 요소들의 높이를 맞춤 */
      }

      .comment-input {
        flex-grow: 1; /* textarea가 가능한 많은 공간 차지 */
        margin-right: 10px; /* 버튼과의 간격 */
      }

      .comment-submit {
        padding: 10px;
        background-color: blue;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
      }
      .comment-submit:hover {
        background-color: darkblue;
      }
      .comment-list {
        margin-top: 20px;
        list-style-type: none;
        padding: 0;
      }
      .comment-item {
        background-color: #f0f0f0;
        padding: 10px;
        margin-bottom: 10px;
        border-radius: 5px;
        position: relative;
        display: flex; 
        align-items: center; 
      }
      .comment-text {
        flex: 1; 
      }
      .comment-delete {
        cursor: pointer;
        color: red;
        margin-left: 10px; 
      }
    </style>
  </head>
  <body>
    <div class="header">
        <h2><c:out value="${sessionScope.user.username}"/>님, 환영합니다.</h2>
        <div class="header-actions">
            <a href="<c:url value='/withdrawal'/>" id="withdrawal" class="header-button">회원탈퇴</a>
            <a href="<c:url value='/sign_out'/>" class="header-button">로그아웃</a>
        </div>
    </div>
    <div class="comment-box">
        <div class="comment-form">
            <textarea class="comment-input" placeholder="댓글을 작성하세요..."></textarea>
            <button class="comment-submit">댓글 작성</button>
        </div>
        <ul class="comment-list">
            <c:forEach items="${comments}" var="comment">
                <li>
                    <c:out value="${comment.user.username}"/>: <c:out value="${comment.text}"/>
                    <c:if test="${comment.user.username == sessionScope.user.username}">
                        <span class="comment-delete" data-comment-id="${comment.id}">X</span>
                    </c:if>
                </li>
            </c:forEach>
        </ul>
    </div>
    <script th:inline="javascript">
        var username = '<c:out value="${sessionScope.user.username}"/>';
    
        // 회원 탈퇴 확인
        document.addEventListener('DOMContentLoaded', function() {
          var withdrawalButton = document.querySelector('#withdrawal');
        
          if (withdrawalButton) {
            withdrawalButton.addEventListener('click', function(event) {
    
              var confirmResult = confirm('회원 탈퇴 하시겠습니까?');
              if (!confirmResult) {
                event.preventDefault();
              }
            });
          }
    
        });
    
        // 댓글 추가
        document.querySelector(".comment-submit").addEventListener("click", function () {
          var input = document.querySelector(".comment-input");
          var text = input.value.trim();
          if (text) {
            fetch('/add_comment', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
              },
              body: 'text=' + encodeURIComponent(text)
            })
            .then(response => response.text())
            .then(() => {
              window.location.reload(); 
            });
          }
        });
    
        // 댓글 삭제
        document.addEventListener('click', function(event) {
          if (event.target.classList.contains('comment-delete')) {
            var commentId = event.target.getAttribute('data-comment-id');
            fetch('/delete_comment/' + commentId, {
              method: 'GET'
            })
            .then(response => response.text())
            .then(() => {
              window.location.reload(); 
            });
          }
        });
      </script>
  </body>
</html>
