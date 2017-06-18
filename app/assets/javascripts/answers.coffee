# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(@).hide()
    answer_id = $(@).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $(document).on 'ajax:success', 'a.up-vote, a.down-vote, a.un-vote', (e, data, status, xhr) ->
    vote_id = '#vote-' + data.votable_type.toLowerCase() + '-' + data.votable_id
    $('#error').html('')
    $(vote_id).html(data.result_votes)
  .bind 'ajax:error', (e, xhr, status, error) ->
    error_info =  $.parseJSON(xhr.responseText)
    $('#error').html(error_info.error)

$(document).on('turbolinks:load', ready)
