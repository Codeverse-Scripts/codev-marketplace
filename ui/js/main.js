let playerItems = [];
let sellingItems = [];
let categorisedItems = [];
let itemBuying = {}; 

$(function(){
    window.addEventListener('message', function(event){
        let action = event.data.action;

        switch(action){
            case "openMenu":
                $.post(`https://${GetParentResourceName()}/getData`, JSON.stringify(), function(data){
                    playerItems = Object.values(data.playerItems);
                    sellingItems = Object.values(data.sellingItems);
                    RefreshCategories(Object.values(data.categories));
                    $("body").fadeIn();
                    ResetInputs()
                });

                break;
            default:
                break;
        }
    });

    $(".button").click(function(){
        $("body").fadeOut(100);
        $.post(`https://${GetParentResourceName()}/closeMenu`);
        $(".pop-up-wrapper").fadeOut(100);
        $("#search-bar").val("");
    })

    $("#sell-pop-btn").click(function(){
        $("#item-select").show();
        $("#item-sell").hide();
        $("#item-buy").hide();
        $(".pop-up-wrapper").fadeIn(100);
        $(".pop-up-wrapper").css("dislay", "flex");
        $("#item-select .items-wrapper").html("");

        playerItems.forEach(item => {
            $("#item-select .items-wrapper").append(`
            <div class="item" data-item="${item.name}">
                <div class="item-image">
                    <img src="${item.image}">
                </div>

                <div class="item-name">${item.label}</div>
                <div class="btn select-btn">SELECT</div>
            </div>
            `);
        });

        ResetInputs()
    })

    $(document).on("click", ".inspect-btn",function(){
        let itemName = $(this).attr("data-name");
        let identifier = $(this).attr("data-seller");
        let item = {};

        sellingItems.forEach(function(i){
            i.items.forEach(function(i2){
                if(i2.name == itemName && i2.seller == identifier){
                    item = i2;
                    itemBuying = i2;
                }
            })
        });

        $("#item-select").hide();
        $("#item-sell").hide();
        $("#item-buy").show();
        $("#item-buy").css("display", "flex");

        $("#item-buy .item-image").html(`<img src="${item.image}">`);
        $("#item-buy .item-name").html(item.label);
        $("#val-box-2 span").text(item.amount)
        $("#item-buy #price-input-2").val(`${item.price}`);

        $(".pop-up-wrapper").fadeIn(100);
        $(".pop-up-wrapper").css("dislay", "flex");
    })

    $(document).on("click", ".buy-confirm",function(){
        let amount = parseInt($("#amount-input-2").val());

        if(amount <= 0){
            $("#amount-input-2").val(1)
        }else if(itemBuying.amount < amount){
            $("#amount-input-2").val(itemBuying.amount)
        }

        $.post(`https://${GetParentResourceName()}/buyItem`, JSON.stringify({
                item: itemBuying,
                amount: amount,
                price: $("#price-input-2").val()
            }), function(cb){
                if(cb){
                    $(".pop-up-wrapper").fadeOut(100);
                    $("body").fadeOut(100);
                    ResetInputs()
                }
            });
    })

    $(".close-btn").click(function(){
        ResetInputs()
        $(".pop-up-wrapper").fadeOut(100);
    })

    $(".back-btn").click(function(){
        $("#item-select").show();
        $("#item-select").css("display", "flex");
        $("#item-sell").hide();
        $("#item-buy").hide();
    })

    $("#amount-input").on("keydown", function(){
        setTimeout(() => {
            let maxamount = $("#val-box-1 span").text()
            let amount = parseInt($(this).val())

            if(amount <= 0){
                $(this).val(1)
            }else if(maxamount < amount){
                $(this).val(maxamount)
            }  
        }, 10);
    })

    $("#search-bar").on("input", function(){
        let value = $(this).val().toLowerCase();

        $("#main-items .item").each(function(){
            let name = $(this).find(".item-name").text().toLowerCase();

            if(name.includes(value)){
                $(this).show();
            }else{
                $(this).hide();
            }
        })
    })

    $(document).on("click", ".select-btn",function(){
        let itemName = $(this).parent().attr("data-item");
        let item = {};

        playerItems.forEach(function(i){
            if(i.name == itemName){
                item = i;
            }
        });

        $("#val-box-1 span").text(item.count)

        $("#item-select").hide();
        $("#item-buy").hide();
        $("#item-sell").show();
        $("#item-sell").css("display", "flex");

        $("#item-sell .item-image").html(`<img src="${item.image}">`);
        $("#item-sell .item-name").html(item.label);

        $("#item-sell .sell-confirm").attr("data-item", itemName);
        ResetInputs()
    })

    $(".sell-confirm").on("click", function(){
        let itemName = $(this).attr("data-item");
        let amount = parseInt($("#amount-input").val());
        
        playerItems.forEach(item => {
            if(item.name == itemName){
                if(item.count >= amount){
                    $.post(`https://${GetParentResourceName()}/addItem`, JSON.stringify({
                        item: item,
                        amount: amount,
                        category: item.category,
                        price: $("#price-input").val()
                    }), function(cb){
                        if(cb){
                            $(".pop-up-wrapper").fadeOut(100);
                            $("body").fadeOut(100);
                            ResetInputs()
                        }
                    });
                }
                else{
                    console.log("item amount is less than amount")
                    return;
                }
            }
            else{
                console.log("item not found")
                return;
            }
        });
    })
})

function RefreshCategories(categories){
    $(".categories").html("");
    categorisedItems = [];

    categories.forEach(function(category, i){
        categorisedItems.push({[category.name]: {
            name: category.name,
            label: category.label,
            description: category.description,
            image: category.image,
            items: []
        }});

        $(".categories").prepend(`
            <div class="category">
                <div class="category-image">
                    <img src="${category.image}">
                </div>
                <div class="category-content">
                    <div class="name">${category.label}</div>
                    <div class="desc">${category.description}</div>
                </div>
                <div class="btn" data-id="${i}" data-name="${category.name}"><img src="assets/img/right-arrow.png"></div>
            </div>
        `);

        $(".category .btn").click(function(){
            $(".category").removeClass("active");
            $(this).parent().addClass("active");
            RefreshItems($(this).attr("data-id"));
        })
    })

    CategoriseItems(categories);
}

function CategoriseItems(categories){
    categories.forEach(category => {
        sellingItems.forEach(data => {
            data.items.forEach(item => {
                if(item.category == category.name){
                    categorisedItems.forEach(categorisedItem => {
                        if(Object.keys(categorisedItem)[0] == category.name){
                            categorisedItem[category.name].items.push(item);
                        }
                    });
                }
            });
        });
    });

    $(".category:first-child").find(".btn").click();
}

function RefreshItems(categoryId){
    let selectedCategory = {}
    selectedCategory = categorisedItems[categoryId];
    selectedCategory = Object.values(selectedCategory)[0];
    selectedCategory.items = Object.values(selectedCategory.items);
    $("#main-items").html("");

    selectedCategory.items.forEach(item => {
        $("#main-items").append(`
        <div class="item">
            <div class="item-image">
                <img src="${item.image}">
            </div>

            <div class="item-name">${item.label}</div>
            <div class="item-price">${item.price} <span>By ${item.playerName}</span></div>
            <div class="btn inspect-btn" data-name="${item.name}" data-seller="${item.seller}">INSPECT</div>
        </div>
        `);
    });
}

function ResetInputs(){
    $("#amount-input").val("");
    $("#price-input").val("");
    $("#amount-input-2").val("");
    $("#price-input-2").val("");
}