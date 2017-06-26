import React from 'react';
import ReactDOM from 'react-dom';
import Immutable from 'immutable';

import WindowManager from './window-manager';
import Window from './window';


//
// Application handles storing and updating model data
//

class App extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.state = {
      models: Immutable.List([
        {id: 0, index: 0},
        {id: 1, index: 1},
        {id: 2, index: 2},
      ]),
      nextId: 3,
      line: [0, 0]
    };
    
    this.createNewModel = this.createNewModel.bind(this);
    this.handleWindowMove = this.handleWindowMove.bind(this);
  }

  handleWindowMove(x, y) {
    this.setState(state => ({
//      line: [x, y]
    }));
  }

  createNewModel() {
    this.setState(state => ({
      models: state.models.concat({id: state.nextId, index: 2}),
      nextId: state.nextId + 1
    }));
  }

  render() {
    console.log('App#render()');
    
    return (
      <div>
        <svg id="background" width="100%" height="100%">
          <line x1="50%" y1="50%" x2={this.state.line[0]} y2={this.state.line[1]} stroke="hsl(0, 0%, 25%)" strokeWidth="1" />
        </svg>
        <Menu onCreateNewModel={this.createNewModel} />
        
        <WindowManager>
          {this.state.models.map(model => {
            return (
              <Window key={model.id} id={model.id} onWindowMove={this.handleWindowMove}>
                <ModelContainer id={model.id} />
              </Window>
            );
          })}
        </WindowManager>
      </div>
    );
  }
  
}


//
// MenuBar displays a horizontal menu with vertical sub-menus
//

class Menu extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.createNewModel = this.createNewModel.bind(this);
  }
  
  createNewModel() {
    this.props.onCreateNewModel();
  }

  render() {
    console.log('Menu#render()');
    
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


//
// Model is a container that works with individual model views
//

class ModelContainer extends React.PureComponent {

  constructor(props) {
    super(props);
  }
  
  render() {
    console.log('ModelContainer#render()');
    
    return <ModelView />;
  }

}


//
//
//

function ModelView(props) {
  return (
    <ul>
      <li><CellContainer /><CellContainer /><CellContainer /></li>
      <li><CellContainer /><CellContainer /><CellContainer /></li>
      <li><CellContainer /><CellContainer /><CellContainer /></li>
      <li><CellContainer /><CellContainer /><CellContainer /></li>
      <li><CellContainer /><CellContainer /><CellContainer /></li>
    </ul>
  );
}


//
// CellContainer handles UI state for CellView presentation components
//

class CellContainer extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.state = {
      active: false
    };
    
    this.handleOnFocus = this.handleOnFocus.bind(this);
    this.handleOnBlur = this.handleOnBlur.bind(this);
    this.handleOnKeyDown = this.handleOnKeyDown.bind(this);
  }

  handleOnFocus(event) {
    event.target.select();

    this.setState({
      active: true
    });
  }

  handleOnBlur(event) {
    this.setState({
      active: false,
      editing: false
    });
  }

  handleOnKeyDown(event) {
    console.log(event.key);
    
    if (["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].indexOf(event.key) !== -1) {
      event.stopPropagation();
      event.preventDefault();
    } else {
      this.setState({
        editing: true
      });
    }
    
    if (event.key === "Enter") {
      event.stopPropagation();
      event.preventDefault();

      event.target.select();
      
      this.setState({
        editing: false
      });
    }
  }

  render() {
    var style = this.state.active ? {
      border: "3px solid hsl(0, 0%, 25%)",
      position: "relative",
      zIndex: 1,
    } : { };
    
    return <input type="text" pattern="[0-9]" readOnly={!this.state.editing} onChange={event => 0} onFocus={this.handleOnFocus} onBlur={this.handleOnBlur} style={style} onKeyDown={this.handleOnKeyDown} />;
  }

}

ReactDOM.render(
  <App />,
  document.getElementById('app')
);
