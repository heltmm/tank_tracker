

var modal = (function () {

  var populateForm = function(tank) {
    var cellear_update = `



    `
    $("#tank-number").html(tank.tank_type + tank.number)
    switch(tank.status) {
    case "dirty":
      $("#celler_update").show()
      $("#change_status").html(
        "<option value='clean'>Clean</option>"
      )
      $("#brewer_update").hide()
      $("#transfer_update").hide()

      break;
    case "clean":
      $("#celler_update").show()
      $("#change_status").html(
        "<option value='sanitized'>Sanitized</option>" +
        "<option value='dirty'>Dirty</option>"
      )
      $("#brewer_update").hide()
      $("#transfer_update").hide()

      break;
    case "sanitized":
      $("#celler_update").show()
      $("#change_status").html(
        "<option value='sanitized'>Clean</option>" +
        "<option value='dirty'>Dirty</option>"
      )
      if (tank.tank_type === "FV") {
        $("#brewer_update").show()
      }
      $("#transfer_update").hide()

      break;
    default:
    // "active"
      $("#celler_update").hide()
      $("#brewer_update").hide()
      $("#transfer_update").show()



    }
  };

  return {
    populateForm: populateForm
  };

})();
