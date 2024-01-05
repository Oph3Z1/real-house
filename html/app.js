const app = new Vue({
    el: '#app',
    data: {
        page: 'house-management', // 'buyhouse' - 'garage' - 'house-management'
        rented: false,
        popupscreen: false, // 'add-slot' - 'rent-settings' - 'request-screen' - 'sellrenthouse' - 'house-settings'
        rentsellhouseoption: false, // 'sell' - 'rent'
        rentallowed: false,
        friends: [
            {id: 1, firstname: 'Oph3Z', lastname: 'HouseV2', img: 'img/ursupp.png'},
            {id: 2, firstname: 'Yusuf', lastname: 'Karacolak', img: 'https://cdn.discordapp.com/attachments/936406344515350538/1151901225508425840/image.png'},
            {id: 3, firstname: 'Test', lastname: 'Falan', img: 'img/ursupp.png'},
        ],
        nerabyplayers: [
            {id: 4, firstname: 'Ananın', lastname: 'Amı', img: 'img/ursupp.png'},
            {id: 5, firstname: 'Ebenin', lastname: 'Amı', img: 'img/ursupp.png'},
            {id: 6, firstname: 'Teyzenin', lastname: 'Amı', img: 'img/ursupp.png'},
        ],
    },
    
    methods: {
        ChangeScreens(page, popupscreen) {
            if(page != null) {
                this.page = page
            }
            if(popupscreen != null) {
                this.popupscreen = popupscreen
            }
        },

        AddToFriends(id, firstname, lastname, img) {
            const CheckFriendsExistens = this.friends.find(marketitem => marketitem.firstname === firstname)
            if (!CheckFriendsExistens) {
                var data = {
                    id,
                    firstname,
                    lastname,
                    img
                }
                this.friends.push(data)
            }
        },

        RemoveFromFriends(id) {
            const BasketItem = this.friends.find(data => data.id === id)
            this.friends.splice(this.friends.indexOf(BasketItem), 1)
        },

        RemoveFromNearbyPlayers(id) {
            const NearbyPlayer = this.nerabyplayers.find(data => data.id === id);
            this.nerabyplayers.splice(this.nerabyplayers.indexOf(NearbyPlayer), 1);
        },
    },
});