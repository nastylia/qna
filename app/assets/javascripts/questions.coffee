# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  questionsList = $(".questions-list")
  $('body').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(@).hide()
    $('form#edit-question').show()

  $('body').on 'click', '#add-comments-question', (e) ->
    e.preventDefault()
    $('form.comment-question').show()

  $(document).on 'ajax:success', 'form.comment-question, form.comment-answer', (e, data, status, xhr) ->
    comments = '#comments-' + data.commentable_type.toLowerCase() + '-' + data.commentable_id
    comment_form = '#add-comment-' + data.commentable_type.toLowerCase() + '-' + data.commentable_id
    $(comments).append("<li>" + data.comment + "</li>")
    $(comment_form + ">#comment_comment").val("")
    $(comment_form).hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    error_info =  $.parseJSON(xhr.responseText)
    $('#error').html(error_info.error)

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionsList.append data
  })

$(document).on('turbolinks:load', ready)
