ready = ->

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      return unless gon.question_id
      @perform 'follow', question_id: gon.question_id
    ,

    received: (data) ->
      return if data.comment.user_id == gon.user_id
      commentsList = $("ul#comments-#{data.comment.commentable_type.toLowerCase()}-#{data.comment.commentable_id}")
      commentsList.append(JST["skim_templates/comment"](data))
  })
$(document).on('turbolinks:load', ready)
