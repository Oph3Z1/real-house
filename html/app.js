const store = Vuex.createStore({
    state: {},
    mutations: {},
    actions: {}
});

const app = Vue.createApp({
    data: () => ({
        Show: false,
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
            {id: 4, firstname: 'Ananın', lastname: 'Blip', img: 'img/ursupp.png'},
            {id: 5, firstname: 'Ebenin', lastname: 'Blip', img: 'img/ursupp.png'},
            {id: 6, firstname: 'Teyzenin', lastname: 'Blip', img: 'img/ursupp.png'},
        ],

        // Other informations

        playername: '',
        pfp: '',
        playerbank: 0,
        playercash: 0,
        housename: '',
        houseprice: 0,
        houserentprice: 0,
        housedescription: '',
        allowgarage: null,
        garageslot: 0,
    }),

    methods: {    
        PE3D(s) {
            s = parseInt(s)
            return s.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
        },

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
        
        CloseUI() {
            this.Show = false
            this.page = ''
            this.rented = false
            this.popupscreen = false
            this.rentsellhouseoption = false
            this.rentallowed = false
            this.playername = ''
            this.pfp = ''
            this.playerbank = 0
            this.playercash = 0
            this.housename = ''
            this.houseprice = 0
            this.houserentprice = 0
            this.housedescription = ''
            this.garageslot = 0
            this.allowgarage = null
        },
    },

    computed: {
        
    },

    watch: {
    
    },

    beforeDestroy() {
        window.removeEventListener('keyup', this.onKeyUp);
    },

    mounted() { 
        window.addEventListener("message", event => {
            const data = event.data;

            if (data.action == 'OpenBuyMenu') {
                this.Show = true
                this.page = 'buyhouse'
                this.housename = data.houseinfo.HouseName
                this.housedescription = data.houseinfo.HouseDescription
                this.allowgarage = data.houseinfo.AllowGarage
                this.garageslot = data.houseinfo.AvailableSlot
                this.playername = data.playername
                this.pfp = data.pfp
                this.playerbank = data.playerbank
                this.playercash = data.playercash
                this.houseprice = data.houseprice
                this.houserentprice = data.houserentprice
            }
        });

        window.addEventListener('keydown', (event) => {
            if (event.key == 'Escape') {
                if (this.Show) {
                    this.CloseUI()
                    postNUI('CloseUI')
                }
            }
        });
    },      
});

app.use(store).mount("#app");

const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : "real-house";

window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrerPolicy: "no-referrer",
            body: JSON.stringify(data)
        });
        return !response.ok ? null : response.json();
    } catch (error) {
        // console.log(error)
    }
};