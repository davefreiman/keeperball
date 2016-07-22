var NewTradeForm = (function(){
    'use strict';

    var handleFromTeamChange = function($fromTrigger) {
            $fromTrigger.on('change', function(){
                alert('from team change');
            });
        },

        handleToTeamChange = function($toTrigger) {
            $toTrigger.on('change', function(){
                alert('to team change');
            });
        },

        init = function() {
            var $fromTrigger = $('[data-from-team-trigger]'),
                $toTrigger = $('[data-to-team-trigger]');

            if (_.isEmpty($fromTrigger) || _.isEmpty($toTrigger)){ return; }

            handleFromTeamChange($fromTrigger);
            handleToTeamChange($toTrigger);
        };

    return {
        init: init
    }

})();

$(document).ready(function(){
    NewTradeForm.init();
});