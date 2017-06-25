# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  answersList = $(".answers")
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(@).hide()
    answer = $(e.target).closest('.answer')
    form = answer.find('.edit_answer')
    form.show()

  $('body').on 'click', '#add-comments-answer', (e) ->
    e.preventDefault()
    answer = $(e.target).closest('.answer')
    form = answer.find('form.comment-answer')
    $(form).show()

  $(document).on 'ajax:success', 'a.up-vote, a.down-vote, a.un-vote', (e, data, status, xhr) ->
    vote_id = '#vote-' + data.votable_type.toLowerCase() + '-' + data.votable_id
    $('#error').html('')
    $(vote_id).html(data.result_votes)
  .bind 'ajax:error', (e, xhr, status, error) ->
    error_info =  $.parseJSON(xhr.responseText)
    $('#error').html(error_info.error)

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      return unless gon.question_id
      @perform 'follow', question_id: gon.question_id
    ,

    received: (data) ->
      return if data.answer.author_id == gon.user_id
      answersList.append(JST["skim_templates/answer"](data))
  })

$(document).on('turbolinks:load', ready)
