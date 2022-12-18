let ItemSelected = undefined;
let personalInv = false;
let invType = undefined;
const ammoTypes = {
    1: "9mm Bullets",
    2: "12 Gauge Bullets",
    3: ".308 Sniper Rounds",
    4: "7.62mm Bullets",
    5: "5.56mm NATO",
    6: ".357 Bullets",
    7: "Police Issued 5.56mm",
    8: "Police Issued .308 Sniper Rounds",
    9: "Police Issued 9mm",
    10: "Police Issued 12 Gauge",
};

function ClearPersonalInventory() {
    $('.ItemTable').each(function(i, obj) {
        if (!$(this).hasClass("ExampleTable")) {
            $(this).remove();
        }
    });
    $(ItemSelected).removeClass('ItemSelected')
    ItemSelected = undefined;
}

function ClearSecondaryInventory() {
    $('.ItemSecondTable').each(function(i, obj) {
        if (!$(this).hasClass("ExampleSecondTable")) {
            $(this).remove();
        }
    });
    $(ItemSelected).removeClass('ItemSelected')
    ItemSelected = undefined;
    $('#ndInventoryText').show();
}

$(document).ready(function() {
    $('#UseBtn').click(function() {
        if (personalInv) {
            $.post(`https://${GetParentResourceName()}/UseBtn`, JSON.stringify({ invType: 'Plr', itemId: $(ItemSelected).attr('id') }));
        } else {
            $.post(`https://${GetParentResourceName()}/UseBtn`, JSON.stringify({ invType: 'notpersonalinv' }));
        }
    }) 
    $('#UseAllBtn').click(function() {
        if (personalInv) {
            $.post(`https://${GetParentResourceName()}/UseAllBtn`, JSON.stringify({ invType: 'Plr', itemId: $(ItemSelected).attr('id') }));
        } else {
            $.post(`https://${GetParentResourceName()}/UseAllBtn`, JSON.stringify({ invType: 'notpersonalinv' }));
        }
    })
    $('#DropBtn').click(function() {
        if (personalInv) {
            $.post(`https://${GetParentResourceName()}/TrashBtn`, JSON.stringify({ invType: 'Plr', itemId: $(ItemSelected).attr('id') }));
        } else {
            $.post(`https://${GetParentResourceName()}/TrashBtn`, JSON.stringify({ invType: 'notpersonalinv' }));
        }
    })
    $('#GiveBtn').click(function() {
        if (personalInv) {
            $.post(`https://${GetParentResourceName()}/GiveBtn`, JSON.stringify({ invType: 'Plr', itemId: $(ItemSelected).attr('id') }));
        } else {
            $.post(`https://${GetParentResourceName()}/GiveBtn`, JSON.stringify({ invType: 'notpersonalinv' }));
        }
    })
    $('#MoveBtn').click(function() {
        if (personalInv) {
            $.post(`https://${GetParentResourceName()}/MoveBtn`, JSON.stringify({ invType: 'Plr', itemId: $(ItemSelected).attr('id') }));
        } else {
            $.post(`https://${GetParentResourceName()}/MoveBtn`, JSON.stringify({ invType: invType, itemId: $(ItemSelected).attr('id') }));
        }
    })
    $('#MoveXBtn').click(function() {
        if (personalInv) {
            $.post(`https://${GetParentResourceName()}/MoveXBtn`, JSON.stringify({ invType: 'Plr', itemId: $(ItemSelected).attr('id') }));
        } else {
            $.post(`https://${GetParentResourceName()}/MoveXBtn`, JSON.stringify({ invType: invType, itemId: $(ItemSelected).attr('id') }));
        }
    })
    $('#MoveAllBtn').click(function() {
        if (personalInv) {
            $.post(`https://${GetParentResourceName()}/MoveAllBtn`, JSON.stringify({ invType: 'Plr', itemId: $(ItemSelected).attr('id') }));
        } else {
            $.post(`https://${GetParentResourceName()}/MoveAllBtn`, JSON.stringify({ invType: invType, itemId: $(ItemSelected).attr('id') }));
        }
    })
})

window.addEventListener('message', function(event) {
    var msg = event.data;
    if (msg.action == "InventoryDisplay" && msg.showInv) {
        $('#MainInventoryContainer').show();
        $('#ndInventoryText').show();
    } else if (msg.action == "InventoryDisplay" && !msg.showInv) {
        $('#MainInventoryContainer').hide();
        invType = undefined;
        ClearPersonalInventory();
        ClearSecondaryInventory();
        $('#PersonalInventoryWeight').text(`0/0kg`)
        $('#SecondInventoryWeight').text(`0/0kg`)
        $('#SecondInventoryWeight').hide();
        $('#PersonalInventoryWeight').css('color', 'white');
    }
    if (msg.action == "loadItems") {
        ClearPersonalInventory();
        for (var key in msg.items) {
            let newItem = $('.ExampleTable').clone().appendTo("#PersonalInventoryTable");
            $(newItem).find(".ItemName").text(msg.items[key].ItemName)
            $(newItem).find(".ItemQuantity").text(msg.items[key].amount)
            $(newItem).find(".ItemKG").text((msg.items[key].Weight * msg.items[key].amount).toFixed(2) + "kg")
            $(newItem).removeClass('ExampleTable')
            $(newItem).show();
            $(newItem).attr("id", key)
        }
        if (msg.CurrentKG < 15) {
            $('#PersonalInventoryWeight').css('color', 'white');
        } else if (msg.CurrentKG < 25) {
            $('#PersonalInventoryWeight').css('color', 'white');
        } else if (msg.CurrentKG > 25) {
            $('#PersonalInventoryWeight').css('color', 'white');
        }
        $('#PersonalInventoryWeight').text(`${(msg.CurrentKG).toFixed(2)}/${msg.MaxKG}kg`)
        $('.ItemTable').each(function(i, obj) {
            if (!$(this).hasClass("ExampleTable")) {
                $(this).click(function() {
                    if (ItemSelected) {
                        $(ItemSelected).removeClass('ItemSelected')
                    }
                    ItemSelected = $(this)
                    $(this).addClass('ItemSelected')
                    personalInv = true;
                    var x = document.getElementById("UseAllBtn");
                    x.style.display = "none";
                    for (const property in ammoTypes) {
                        if ($(ItemSelected).attr('id') === ammoTypes[property]) {
                            x.style.display = "block";
                        }
                    }
                })
            }
        });
    }
    if (msg.action == "loadSecondaryItems") {
        invType = msg.invType
        ClearSecondaryInventory();
        for (var key in msg.items) {
            let newItem = $('.ExampleSecondTable').clone().appendTo("#SecondaryInventoryTable");
            $(newItem).find(".ItemName").text(msg.items[key].ItemName)
            $(newItem).find(".ItemQuantity").text(msg.items[key].amount)
            $(newItem).find(".ItemKG").text((msg.items[key].Weight * msg.items[key].amount).toFixed(2) + "kg")
            $(newItem).removeClass('ExampleSecondTable')
            $(newItem).show();
            $(newItem).attr("id", key)
        }
        $('#SecondInventoryWeight').show();
        $('#SecondInventoryWeight').text(`${(msg.CurrentKG).toFixed(2)}/${msg.MaxKG}kg`)
        $('.ItemSecondTable').each(function(i, obj) {
            if (!$(this).hasClass("ExampleSecondTable")) {
                $(this).click(function() {
                    if (!ItemSelected) {
                        $(this).addClass('ItemSelected')
                        ItemSelected = $(this)
                        personalInv = false;
                    } else {
                        $(ItemSelected).removeClass('ItemSelected')
                        ItemSelected = $(this)
                        $(this).addClass('ItemSelected')
                        personalInv = false;
                    }
                })
            }
        });
        $('#ndInventoryText').hide();
    }
});