# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/ujs", to: "https://cdn.jsdelivr.net/npm/@rails/ujs@latest/dist/rails-ujs.js"

pin "navbar" # @3.0.0
pin "navbar", to: "navbar.js"
pin "navbar", to: "core.min.js"
pin "navbar", to: "script.js"

pin "vue", to: "https://unpkg.com/vue@3/dist/vue.esm-browser.js"
