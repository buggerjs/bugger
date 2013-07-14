
var nullVar = null;
var undefinedVar = undefined;
var numberVar = 10;
var numberVar2 = 4.37842747726724746538764;
var numberVar3 = 1/0;
var notANumberVar = parseInt('n');
var boolVar = false;
var stringVar = 'Hello World';
var longStringVar = 'Donec ullamcorper nulla non metus auctor fringilla. Nullam id dolor id nibh ultricies vehicula ut id elit. Curabitur blandit tempus porttitor. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Curabitur blandit tempus porttitor. Nullam quis risus eget urna mollis ornare vel eu leo. \
Nulla vitae elit libero, a pharetra augue. Sed posuere consectetur est at lobortis. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Sed posuere consectetur est at lobortis. \
Donec sed odio dui. Nullam quis risus eget urna mollis ornare vel eu leo. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Donec ullamcorper nulla non metus auctor fringilla.';

var arrayVar = [ 1, 2, 3 ];
var objVar = { foo: 'bar' };

var regexVar = /^foo$/g;
var dateVar = new Date(1368987692964);

function functionVar() {
  this.member = 42;
};
functionVar.prototype.someFun = function() { console.log('someFun'); };
var instance = new functionVar();

console.log('This should contain examples of most types');
