class CourseBattleChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "course_battle_chat_#{params[:courseBattleId]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def sendMessage(data)

  end
end
