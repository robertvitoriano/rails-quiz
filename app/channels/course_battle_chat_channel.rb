class CourseBattleChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "course_battle_chat_#{params[:courseBattleId]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)

  end
  def send_is_typing(data)
    ActionCable.server.broadcast("course_battle_chat_#{params[:courseBattleId]}",{userId:data["userId"], courseBattleId:params[:courseBattleId], type:"is_typing"})
  end
  def send_stop_typing(data)
    ActionCable.server.broadcast("course_battle_chat_#{params[:courseBattleId]}", {userId:data["userId"],courseBattleId:params[:courseBattleId], type:"stop_typing"})
  end

end
