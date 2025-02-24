part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final List<MessageModel> messages;

  ChatMessagesLoaded(this.messages);
}

class ChatMessageReceived extends ChatState {
  final MessageModel message;

  ChatMessageReceived(this.message);
}

class ChatMessageSent extends ChatState {}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
