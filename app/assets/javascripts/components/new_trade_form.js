var NewTradeForm = (function(){
    'use strict';

    var handleFromTeamChange = function($fromTrigger) {
            var $fromTeam = $('[data-from-team-fields]');
            if (_.isEmpty($fromTeam)) { return; }

            $fromTrigger.on('change', function() {
                $.ajax({
                    url: '/rosters/trade_form',
                    data: {
                        team_type: 'from',
                        roster: $(this).val()
                    },
                    dataType: 'json'
                }).always(function(response){
                    $fromTeam.html(response.responseText);
                });
            }).trigger('change');
        },

        handleToTeamChange = function($toTrigger) {
            var $toTeam = $('[data-to-team-fields]');
            if (_.isEmpty($toTeam)) { return; }

            $toTrigger.on('change', function(){
                $.ajax({
                    url: '/rosters/trade_form',
                    data: {
                        team_type: 'to',
                        roster: $(this).val()
                    },
                    dataType: 'json'
                }).always(function(response){
                    $toTeam.html(response.responseText);
                });
            }).trigger('change');
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