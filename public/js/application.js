$(document).ready(function(){
  var $answer_element = $('.answer').first().clone();
  var $question_element = $('.question').first().clone();
  var question_index = 0;

  $(document).on('click', '.add-answer', function(e) {
    e.preventDefault();
    var $added = $answer_element.clone();
    var indexToAddAnswer = $(this).parent().index();
    $added.attr('name',"questions[" + indexToAddAnswer + "][answers][]");
    $(this).parent().append($added);
  });

  $(document).on('click', '.add-question', function(e){
    e.preventDefault();
    question_index++;
    var $added = $question_element.clone();
    $added.find('input').first().attr('name',"questions[" + question_index + "][question_text]");
    $added.find('input').last().attr('name',"questions[" + question_index + "][answers][]");
    $('#questions-answers').append($added);
  });
});


