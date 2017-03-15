alert('Loading...');

gadgets.util.registerOnLoadHandler(function() {
	var itemId = 100, description = 'test', quantity = 10, imageUrl = 'http://';
	gadgets.rpc.call(null, 'initiatePurchase', function() { alert('here'); }, itemId, description, quantity, imageUrl);
	alert('Done.');
});
