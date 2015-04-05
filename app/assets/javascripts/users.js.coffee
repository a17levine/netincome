# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  data = {
    labels : ["Apr 1","Apr 2","Apr 3","Apr 4","Apr 5","Apr 6","Apr 7"],
    datasets : [
      {
        fillColor : "rgba(151,187,205,0.5)",
        strokeColor : "rgba(151,187,205,1)",
        pointColor : "rgba(151,187,205,1)",
        pointStrokeColor : "#fff",
        data : [28,20,40,19,50,40,30]
      }
    ]
  }

  myNewChart = new Chart($("#canvas").get(0).getContext("2d")).Line(data)