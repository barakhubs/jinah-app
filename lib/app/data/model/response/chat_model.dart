class Message {
 final int id;
 final int messageId;
 final int userId;
 final String userName;
 final String userPhone;
 final String userImage;
 final String text;
 final String image;
 final String isRead;
 final String replyAt;

 Message({
   required this.id,
   required this.messageId,
   required this.userId,
   required this.userName,
   required this.userPhone,
   required this.userImage,
   required this.text,
   required this.image,
   required this.isRead,
   required this.replyAt,
 });

 factory Message.fromJson(Map<String, dynamic> json) {
   return Message(
     id: json['id'],
     messageId: json['message_id'],
     userId: json['user_id'],
     userName: json['user_name'],
     userPhone: json['user_phone'],
     userImage: json['user_image'],
     text: json['text'],
     image: json['image'],
     isRead: json['is_read'],
     replyAt: json['reply_at'],
   );
 }
}

class Data {
 final int id;
 final int branchId;
 final int userId;
 final String userName;
 final String userPhone;
 final String userImage;
 final List<Message> message;

 Data({
   required this.id,
   required this.branchId,
   required this.userId,
   required this.userName,
   required this.userPhone,
   required this.userImage,
   required this.message,
 });

 factory Data.fromJson(Map<String, dynamic> json) {
   return Data(
     id: json['id'],
     branchId: json['branch_id'],
     userId: json['user_id'],
     userName: json['user_name'],
     userPhone: json['user_phone'],
     userImage: json['user_image'],
     message: (json['message'] as List)
         .map((i) => Message.fromJson(i))
         .toList(),
   );
 }
}

class ApiResponse {
 final List<Data> data;

 ApiResponse({required this.data});

 factory ApiResponse.fromJson(Map<String, dynamic> json) {
   return ApiResponse(
     data: (json['data'] as List)
         .map((i) => Data.fromJson(i))
         .toList(),
   );
 }
}
