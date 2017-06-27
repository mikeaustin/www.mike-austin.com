import React from 'react';
import ReactDOM from 'react-dom';

import { createStore } from 'redux';

import Immutable from 'immutable';

import WindowManager from './window-manager';
import Window from './window';
import MenuBar from './menu-bar';


function reducer(state = {data: Immutable.Map()}, action) {
  console.log(action);
  
  switch (action.type) {
    case 'SET':
      return {data: state.data.set(action.index, action.value)};
    default:
      return state;
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
      line: [0, 0],
      data: Immutable.Map()
    };
    
    this.createNewModel = this.createNewModel.bind(this);
    this.handleSetValue = this.handleSetValue.bind(this);
    this.handleWindowMove = this.handleWindowMove.bind(this);

    this.store = createStore(reducer);
  }
  
  componentWillMount() {
    this.store.subscribe(() => {
      const state = this.store.getState();
      
      this.setState({
        data: state.data
      });
    });
  }

  handleWindowMove(x, y) {
    this.setState(state => ({
      //line: [x, y]
    }));
  }

  createNewModel() {
    this.setState(state => ({
      models: state.models.concat({id: state.nextId, index: 2}),
      nextId: state.nextId + 1
    }));
  }

  handleSetValue(index, value) {
    this.store.dispatch({type: 'SET', index: index, value: value});
  }

  render() {
    //console.log('App#render()');
    
    return (
      <div>
        <svg id="background" width="100%" height="100%">
          <line x1="50%" y1="50%" x2={this.state.line[0]} y2={this.state.line[1]} stroke="hsl(0, 0%, 25%)" strokeWidth="1" />
        </svg>
        <MenuBar onCreateNewModel={this.createNewModel} />
        
        <WindowManager>
          {this.state.models.map(model => {
            return (
              <Window key={model.id} id={model.id} onWindowMove={this.handleWindowMove}>
                <ModelContainer id={model.id} data={this.state.data} onSetValue={this.handleSetValue}/>
              </Window>
            );
          })}
        </WindowManager>
      </div>
    );
  }
  
}


//
// ModelContainer works with individual model views
//

class ModelContainer extends React.PureComponent {

  constructor(props) {
    super(props);
    console.log("zzz", props.data.get(0));
  }
  
  //componentWllReceiveProps() ?
  
  render() {
    //console.log('ModelContainer#render()');
    
    return <ModelView data={this.props.data} onSetValue={this.props.onSetValue}/>;
  }

}


//
//
//

function ModelView(props) {
  return (
    <ul>
      <li>
        <CellContainer index={0} value={props.data.get(0)} onSubmit={props.onSetValue} />
        <CellContainer index={1} value={props.data.get(1)} onSubmit={props.onSetValue} />
        <CellContainer index={2} value={props.data.get(2)} onSubmit={props.onSetValue} />
      </li>
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
      active: false,
      editing: false,
      value: props.value
    };
    
    this.handleChange = this.handleChange.bind(this);
    this.handleFocus = this.handleFocus.bind(this);
    this.handleBlur = this.handleBlur.bind(this);
    this.handleKeyDown = this.handleKeyDown.bind(this);
  }

  componentWillReceiveProps(props) {
    if (props.value === this.props.value) {
      return;
    }

    //console.log("props", this.props.value);
    
    this.setState({
      value: props.value
    });
  }

  handleChange(event) {
    this.setState({
      value: event.target.value
    });
  }

  handleFocus(event) {
    event.target.select();

    this.setState({
      active: true
    });
  }

  handleBlur(event) {
    this.setState({
      active: false,
      editing: false
    });
    
    if (this.props.onSubmit) {
	  this.props.onSubmit(this.props.index, this.state.value);
    }
  }

  handleKeyDown(event) {
    console.log(event.key);

    if (!this.state.editing) {
      if (["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].indexOf(event.key) !== -1) {
        event.stopPropagation();
        event.preventDefault();
        
        return;
      }
      
      if (event.key === 'Enter') {
        event.target.setSelectionRange(1000, 1000);
        
        event.stopPropagation();
        event.preventDefault();
      }
      
      this.setState({
        editing: true
      });
    } else {
      if (event.key === 'Enter') {
        event.stopPropagation();
        event.preventDefault();

        event.target.select();

        this.setState({
          editing: false
        });

        if (this.props.onSubmit) {
    	  this.props.onSubmit(this.props.index, this.state.value);
        }
      }
    }
  }

  render() {
    var style = this.state.active ? {
      border: "3px solid hsl(0, 0%, 25%)",
      position: "relative",
    } : { };

    if (false) {
      return <input type="text" pattern="[0-9]" defaultValue={this.props.value} style={style} readOnly={!this.state.editing}
                    onChange={this.handleChange} onFocus={this.handleFocus} onBlur={this.handleBlur} onKeyDown={this.handleKeyDown} />;
    } else {
      return <input type="text" pattern="[0-9]" value={this.state.value} style={style} readOnly={!this.state.editing}
                    onChange={this.handleChange} onFocus={this.handleFocus} onBlur={this.handleBlur} onKeyDown={this.handleKeyDown} />;
    }
  }

}

ReactDOM.render(
  <App />,
  document.getElementById('app')
);
