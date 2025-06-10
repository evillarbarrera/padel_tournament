// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import Rails from "@rails/ujs";
import "core.min.js";
Rails.start();
import { createApp } from "vue/dist/vue.esm-bundler.js"
window.createApp = createApp
