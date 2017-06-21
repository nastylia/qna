# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  questionsList = $(".questions-list")
  $('body').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(@).hide()
    $('form#edit-question').show()

App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    console.log 'Connected'
    @perform 'follow'
  ,

  received: (data) ->
    questionsList.append data
})

$(document).on('turbolinks:load', ready)
