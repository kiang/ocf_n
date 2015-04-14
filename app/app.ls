defer-src-setters = []

angular.element(document).ready ->
  for func in defer-src-setters
    func!

angular.module "ocf.tw" <[firebase btford.markdown pascalprecht.translate]>

# Set CORS Config
.config <[$httpProvider $translateProvider ]> ++ ($httpProvider, $translateProvider) ->
  $httpProvider.defaults.useXDomain = true
  delete $httpProvider.defaults.headers.common['X-Requested-With']

  $translateProvider.useStaticFilesLoader do
    prefix: '/translations/'
    suffix: '.json'

  lang = window.location.pathname.split('/').1
  lang = window.navigator.userLanguage or window.navigator.language if lang.match 'html' or document.title.match '找不到'
  if lang is 'zh-TW' or lang is 'en-US'
    $translateProvider.preferredLanguage lang

# defer iframe loading to stop blocking angular.js for loading
.directive \deferSrc ->
  return {
    restrict: 'A',
    link: (scope, iElement, iAttrs, controller) ->
      src = iElement.attr 'defer-src'
      defer-src-setters.push ->
        iElement.attr 'src', src
  }

.controller BuildIdCtrl: <[$scope]> ++ ($scope) ->
  require!<[config.jsenv]>
  $scope.buildId = config.BUILD

.controller langCtrl: <[$scope $window]> ++ ($scope, $window) ->
  $scope.changeLang = (lang) ->
    page = $window.location.pathname.split('/').2
    $window.location.href = '/' + lang + '/' + page
show = ->
  prj-img = $ \#prj-img
  prj-img.animate {opacity: 1}, 500
  [h] = [40 + prj-img.height!]
  $ \#prj-img-div .animate {height: h+"px"}, 500

<- $
$ '.ui.dropdown' .dropdown on: \hover, transition: \fade

<- $
if window.location.pathname.match /projects.html$/
  $ '.navbar-wrapper' .stickUp do
    parts: {
      0: 'openGov',
      1: 'openData',
      2: 'socEngage',
      3: 'newMedia',
      4: 'policyFeedback',
      5: 'comCollaboration'
      },
    itemClass: 'menuItem',
    itemHover: 'active',
    topMargin: 'auto'

if window.location.pathname.match /talk.html$/
  $ '.navbar-wrapper' .stickUp do
    parts: {
      0: 'newtalks',
      1: 'talkvideo',
      2: 'alltalks',
      3: 'invitetalks'
      },
    itemClass: 'menuItem',
    itemHover: 'active',
    topMargin: 'auto'

<- $
$ 'a[href^="#"]' .bind 'click.smoothscroll', (e)->
  e.preventDefault();
  target = this.hash
  $ 'html, body' .stop!.animate {'scrollTop': $ target .offset!.top}, 900, 'swing', ->
    window.location.hash = target;

<-! $
$ '.item .meta' .each ->
  $_ = $ @
  if $_.text! is /\d{4}\/\d{1,2}\/\d{1,2}$/
    return if 30 < moment!diff moment(that.0), \days
    $_.closest \.item .add-class \recent-talk
