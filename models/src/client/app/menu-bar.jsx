import React from 'react';
import Immutable from 'immutable';

//
// MenuBar displays a horizontal menu with vertical sub-menus
//

export default class MenuBar extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.createNewModel = this.createNewModel.bind(this);
  }
  
  createNewModel() {
    this.props.onCreateNewModel();
  }

  render() {
    //console.log('Menu#render()');
    
    return (
      <ul className="menubar">
        <li>
          <h1>Model</h1>
          <ul className="submenu">
            <li><h1 onClick={this.createNewModel}>Create New Model...</h1></li>
            <li><h1>Find Model...</h1></li>
          </ul>
        </li>
        <li>
          <h1>View</h1>
          <ul className="submenu">
            <li><h1>Submenu 1</h1></li>
            <li><h1>Submenu 2</h1></li>
          </ul>
        </li>
        <li>
          <h1>Help</h1>
          <ul className="submenu">
            <li><h1 lang="en">English</h1></li>
            <li><h1 lang="jp">日本語</h1></li>
          </ul>
        </li>
      </ul>
    );
  }

}

class ViewContainer {
}
