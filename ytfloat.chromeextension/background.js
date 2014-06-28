chrome.browserAction.onClicked.addListener(function(activeTab){
  chrome.tabs.getSelected(null, function(tab) {
    var urlToOpen = "ytfloat://" + tab.url;
        chrome.tabs.create({url: urlToOpen}, function(newTab) {
           setTimeout(function(){chrome.tabs.remove(newTab.id);}, 4000);
            });
        });
 });