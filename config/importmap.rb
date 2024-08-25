# Pin npm packages by running ./bin/importmap

pin "application"
pin "sortablejs" # @1.15.2
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.9
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.min.js"





