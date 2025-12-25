import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    establishments: Array
  }

  connect() {
    if (typeof window.L === 'undefined') {
      console.error('Leaflet (L) is not loaded. Ensure leaflet script tag is included in layout before importmap tags.')
      return
    }

    const L = window.L

    // Fix Leaflet default icon paths
    delete L.Icon.Default.prototype._getIconUrl
    L.Icon.Default.mergeOptions({
      iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
      iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
      shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
    })

    this.initMap()
    this.getUserLocation()
  }

  initMap() {
    // Inicializa mapa centrado em São Paulo (fallback)
    this.map = L.map(this.element).setView([-23.5505, -46.6333], 13)

    // Adiciona tile layer do OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors',
      maxZoom: 19
    }).addTo(this.map)

    // Adiciona marcadores dos estabelecimentos
    this.addEstablishmentMarkers()
  }

  getUserLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const lat = position.coords.latitude
          const lng = position.coords.longitude

          // Centraliza no usuário
          this.map.setView([lat, lng], 14)

          // Adiciona marcador do usuário
          const L = window.L
          L.marker([lat, lng], {
            icon: L.divIcon({
              className: 'user-location-marker',
              html: '<div class="w-4 h-4 bg-blue-500 rounded-full border-2 border-white shadow-lg"></div>',
              iconSize: [16, 16]
            })
          }).addTo(this.map).bindPopup('Você está aqui')

          // Atualiza lista por proximidade
          this.updateNearbyList(lat, lng)
        },
        (error) => {
          // Log completo para debugging
          console.error('Erro ao obter localização:', error)

          // Mensagem amigável para o usuário
          try {
            const message = 'Não foi possível obter sua localização — mostrando mapa geral.'
            const toast = document.createElement('div')
            toast.className = 'fixed bottom-24 left-4 right-4 z-50'
            toast.innerHTML = `<div class="bg-yellow-500 text-white px-4 py-3 rounded-lg text-center font-medium">${message}</div>`
            document.body.appendChild(toast)
            setTimeout(() => toast.remove(), 5000)
          } catch (e) {
            console.error('Erro ao mostrar toast de localização:', e)
          }

          // Fallback: centralizar no primeiro estabelecimento disponível
          try {
            if (this.hasEstablishmentsValue && this.establishmentsValue.length > 0 && this.map) {
              const e = this.establishmentsValue[0]
              if (e.latitude && e.longitude) {
                this.map.setView([e.latitude, e.longitude], 13)
              }
            }
          } catch (e) {
            console.error('Erro ao aplicar fallback de localização:', e)
          }
        },
        { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 }
      )
    }
  }

  addEstablishmentMarkers() {
    if (!this.hasEstablishmentsValue) return

    this.establishmentsValue.forEach(establishment => {
      if (establishment.latitude && establishment.longitude) {
        const marker = L.marker([establishment.latitude, establishment.longitude])
          .addTo(this.map)
          .bindPopup(`
            <div class="p-2">
              <h3 class="font-bold text-sm">${establishment.name}</h3>
              <p class="text-xs text-gray-600 mt-1">${establishment.address || ''}</p>
              <a href="/establishments/${establishment.id}" class="text-yellow-600 text-xs font-semibold mt-2 inline-block">Ver detalhes →</a>
            </div>
          `)
      }
    })
  }

  updateNearbyList(lat, lng) {
    // Envia requisição para atualizar lista por proximidade
    const url = new URL(window.location.href)
    url.searchParams.set('lat', lat)
    url.searchParams.set('lng', lng)

    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html'
      }
    })
  }

  disconnect() {
    if (this.map) {
      this.map.remove()
    }
  }
}
