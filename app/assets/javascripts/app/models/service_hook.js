Travis.ServiceHook = Travis.Record.extend({
  primaryKey: 'uid',

  toggle: function() {
    this.toggleWithoutCommit();
    this.commitRecord({ owner: this.get('owner'), name: this.get('name') });
  },
  toggleWithoutCommit: function() {
  	this.writeAttribute('active', !this.get('active'));
  },
});

Travis.ServiceHook.reopenClass({
  resource: 'profile/service_hooks'
});

