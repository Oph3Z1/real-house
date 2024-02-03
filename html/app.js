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
        lastpage: '',
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
        garagetable: [],
        slotinput: '',

        // Garage informations
        currentslot: 0,
        maxslot: 0,
        vehicleowner: '',
        vehicleownerpp: '',
        slotprice: 0,

        // Other informations

        houseid: null,
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
        housebg: '',
        housemngimg: '',
        housesecondimg: '',

        // Important Informations

        rentername: '',
        renterpp: '',
        rentedtime: '',

        // None of your business mate

        allowrentprice: '',
        allowrenttime: '',
        allowrentcheck: false,
        allowrentcheckedafter: '',
    }),

    methods: {    
        PE3D(s) {
            s = parseInt(s)
            return s.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
        },

        ChangeScreens(page, popupscreen) {
            this.lastpage = this.page
            if (page != null) {
                this.page = page
            }

            if (popupscreen != null) {
                this.popupscreen = popupscreen
            }
        },

        AddToFriends(id, name, img) {
            const CheckFriendsExistens = this.friends.find(data => data.name === name)
            if (!CheckFriendsExistens) {
                var data = {
                    id,
                    name,
                    img
                }
                this.friends.push(data)
            }
        },

        RemoveFromFriends(id) {
            const data = this.friends.find(v => v.id === id)
            this.friends.splice(this.friends.indexOf(data), 1)
        },

        RemoveFromNearbyPlayers(id) {
            const NearbyPlayer = this.nerabyplayers.find(data => data.id === id);
            this.nerabyplayers.splice(this.nerabyplayers.indexOf(NearbyPlayer), 1);
        }, 

        BuyHouse() {
            if (this.playerbank >= this.houseprice) {
                postNUI('BuyNormalHouse', this.houseid)
                this.CloseUI()
            } else if (this.playercash >= this.houseprice) {
                postNUI('BuyNormalHouse', this.houseid)
                this.CloseUI()
            } else {
                console.log("You don't have enough money to buy house")
            }
        },

        RentHouse() {
            if (this.playerbank >= this.houseprice) {
                postNUI('RentHouse', this.houseid)
                this.CloseUI()
            } else if (this.playercash >= this.houseprice) {
                postNUI('RentHouse', this.houseid)
                this.CloseUI()
            } else {
                console.log("You don't have enough money to buy house")
            }
        },

        GetOutVehicle(plate) {
            postNUI('GetOutVehicle', {
                plate: plate,
                house: this.houseid
            })
            this.CloseUI()
        },

        CalculateTotalSlotPrice() {
            return this.slotinput * this.slotprice
        },

        BuySlot(type) {
            postNUI('AddSlot', {
                type: type,
                house: this.houseid,
                slot: this.slotinput,
                price: this.slotinput * this.slotprice
            })
            this.CloseUI()
        },

        SaveAllowrentSettings() {
            postNUI('SaveAllowrentSettings', {
                house: this.houseid,
                status: this.rentallowed,
                price: this.allowrentprice,
                time: this.allowrenttime
            })
        },

        ChangeRentallowStatus(type) {
            this.rentallowed = type
            this.allowrentcheckedafter = type
            this.allowrentcheck = true
        },

        GoBackToMain(type) {
            this.popupscreen = false
            if (type == 'house') {
                this.page = 'house-management'
            }
        },
        
        CloseUI() {
            this.Show = false
            this.page = ''
            this.houseid = null
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
            this.currentslot = 0
            this.maxslot = 0
            this.vehicleowner = ''
            this.slotprice = 0
            this.vehicleownerpp = ''
            postNUI('CloseUI')
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
                this.houseid = data.houseid
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
                this.housebg = data.houseimg
            } else if (data.action == 'OpenGarage') {
                this.Show = true
                this.page = 'garage'
                this.garagetable = data.data
                this.houseid = data.house
                this.playerbank = data.playerbank
                this.playercash = data.playercash
                this.pfp = data.pp
                this.currentslot = data.currentslot
                this.maxslot = data.maxslot
                this.slotprice = data.slotprice
                this.vehicleowner = data.vehicleowner
                this.playername = data.name
                this.vehicleownerpp = data.vehicleownerpp
            } else if (data.action == 'OpenManagement') {
                this.Show = true
                this.page = 'house-management'
                this.houseid = data.house
                this.playerbank = data.playerbank
                this.playercash = data.playercash
                this.pfp = data.pp
                this.playername = data.name
                this.friends = data.friends
                this.rentallowed = data.allowrent
                this.allowrentprice = data.rentprice
                this.allowrenttime = data.renttime
                this.nerabyplayers = data.nearbyplayers
                this.housemngimg = data.houseimg
                this.housesecondimg = data.housesecondimg
            }
        });

        window.addEventListener('keydown', (event) => {
            if (event.key == 'Escape') {
                if (this.Show && !this.popupscreen) {
                    if (this.allowrentcheck) {
                        if (!this.allowrentcheckedafter) {
                            postNUI('SaveAllowrentSettings', {
                                house: this.houseid,
                                status: false,
                                price: 0,
                                time: 0
                            })
                        }
                    }
                    this.CloseUI()
                } else if (this.Show && this.popupscreen != false) {
                    if (this.lastpage == 'house-management') {
                        this.GoBackToMain('house')
                    }
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