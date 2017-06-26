import React from 'react';
import ReactDOM from 'react-dom';
import Immutable from 'immutable';


//
// WindowManager
//

class WindowManager extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.state = {
      //stacks: Immutable.List([0, 1, 2])
      //stacks: Immutable.List(React.Children.map(props.children, child => child.props.id)),
      stacks: props.children.map(child => child.props.id),
    };
    
    this.handleBringToFront = this.handleBringToFront.bind(this);
  }
  
  componentWillReceiveProps(props) {
    console.log(props.children.equals(this.props.children));
    //if (React.Children.count(props.children) === React.Children.count(this.props.children)) {
    if (props.children.equals(this.props.children)) {
      return;
    }

    this.setState(state => ({
      //stacks: state.stacks.push(props.children.map(child => child.props.id).last())
      stacks: state.stacks.push(props.children.last().props.id)
    }));
  }
  
  handleBringToFront(id, window) {
    //console.log("zzz", this.state.stacks);
    
    this.setState(state => ({
      stacks: state.stacks.remove(state.stacks.indexOf(id)).push(id)
    }));
  }
  
  render() {
    console.log("WindowManager#render()");
   
    return (
      <div>
        {React.Children.map(this.props.children, child => {
          return React.cloneElement(child, {
            bringToFront: this.handleBringToFront,
            zIndex: this.state.stacks.indexOf(child.props.id)
          });
        })}
      </div>
    );
  }

}


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
                <ModelView id={model.id} onWindowMove={this.handleWindowMove} />
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
// DragHandle
//

class DragHandle extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.handleMouseDown = this.handleMouseDown.bind(this);
    this.handleNativeMouseMove = this.handleNativeMouseMove.bind(this);
    this.handleNativeMouseUp = this.handleNativeMouseUp.bind(this);
  }

  componentDidMount() {
    document.addEventListener("mousemove", this.handleNativeMouseMove, false);
    document.addEventListener("mouseup", this.handleNativeMouseUp, false);
  }

  handleDrag(x, y) {
    this.props.onDrag(x, y);
  }

  handleMouseDown(event) {
    this.lastEvent = {
      clientX: event.nativeEvent.clientX,
      clientY: event.nativeEvent.clientY
    };
    
    event.nativeEvent.stopPropagation();
    event.nativeEvent.preventDefault();
  }

  handleNativeMouseMove(nativeEvent) {
    if (this.lastEvent) {
      var delta = nativeEvent.clientX - this.lastEvent.clientX;
      
      this.handleDrag(nativeEvent.clientX - this.lastEvent.clientX,
                      nativeEvent.clientY - this.lastEvent.clientY);
      
      this.lastEvent = {
        clientX: nativeEvent.clientX,
        clientY: nativeEvent.clientY
      };

      //nativeEvent.stopPropagation();
      //nativeEvent.preventDefault();
    }
  }
  
  handleNativeMouseUp(nativeEvent) {
    this.lastEvent = null;
  }

  render() {
    const child = React.Children.only(this.props.children);
    
    return React.cloneElement(child, {
      onMouseDown: this.handleMouseDown
    });
  }
  
}


//
// Window
//

class Window extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.state = {
      position: {
        x: ModelContainer.nextPosition.x,
        y: ModelContainer.nextPosition.y
      }
    }
    
    this.handleMouseDown = this.handleMouseDown.bind(this);   
    this.handleDrag = this.handleDrag.bind(this);

    ModelContainer.nextPosition = {
      x: ModelContainer.nextPosition.x + 20,
      y: ModelContainer.nextPosition.y + 40
    };

    this.zIndex = 0;
  }

  handleMouseDown() {
    if (this.props.bringToFront) {
      this.props.bringToFront(this.props.id, this);
    }
  }

  handleDrag(deltaX, deltaY) {
    this.props.onWindowMove(this.state.position.x + deltaX + 250, this.state.position.y + deltaY);
    
    this.setState(state => ({
      position: {
        x: state.position.x + deltaX,
        y: state.position.y + deltaY
      }
    }));
  }

  render() {
    console.log("Window#render()");
    
    return (
      <div className="model" style={{left: this.state.position.x + 'px', top: this.state.position.y + 'px', zIndex: this.props.zIndex}} onMouseDown={this.handleMouseDown}>
        <DragHandle onDrag={this.handleDrag}>
          <h1>Model</h1>
        </DragHandle>
        {React.Children.only(this.props.children)}
      </div>
    );
  }
  
}


//
// Model is a container that works with individual model views
//

class ModelContainer extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.zIndex = 0;

    this.handleMouseDown = this.handleMouseDown.bind(this);   
    this.handleDrag = this.handleDrag.bind(this);
    
    this.state = {
      position: {
        x: ModelContainer.nextPosition.x,
        y: ModelContainer.nextPosition.y
      }
    }
    
    ModelContainer.nextPosition = {
      x: ModelContainer.nextPosition.x + 20,
      y: ModelContainer.nextPosition.y + 40
    };
  }

  handleMouseDown() {
    if (this.props.bringToFront) {
      this.props.bringToFront(this.props.id, this);
    }
  }

  handleDrag(deltaX, deltaY) {
    this.props.onWindowMove(this.state.position.x + deltaX + 250, this.state.position.y + deltaY);
    
    this.setState(state => ({
      position: {
        x: state.position.x + deltaX,
        y: state.position.y + deltaY
      }
    }));
  }
  
  render() {
    console.log('ModelContainer#render()');
    
    return (
      <div className="model" style={{left: this.state.position.x + 'px', top: this.state.position.y + 'px', zIndex: this.props.zIndex}} onMouseDown={this.handleMouseDown}>
        <DragHandle onDrag={this.handleDrag}>
          <h1>Model</h1>
        </DragHandle>
        <ModelView position={this.state.position} onDrag={this.handleDrag} onMouseDown={this.handleMouseDown} zIndex={this.props.zIndex} />
      </div>
    );
  }

}

ModelContainer.nextPosition = { x: 200, y: 200 }


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
