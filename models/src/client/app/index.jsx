import React from 'react';
import ReactDOM from 'react-dom';

import { createStore } from 'redux';

import Immutable from 'immutable';

import WindowManager from './window-manager';
import Window from './window';
import MenuBar from './menu-bar';


const LogType = {
  Action:       'Action',
  HandleMethod: 'HandleMethod'
};

const Debug = new class {

  log(type, ...args) {
    if (Debug.LogTypeConfig[type]) {
      console.log.apply(null, [type].concat(args));
    }
  }

}

Debug.LogTypeConfig = {
  Action:       true,
  HandleMethod: true
};


function reducer(state = {data: Immutable.Map([[0, 1000], [1, 500], [2, 2000]])}, action) {
  Debug.log(LogType.Action, action);
  
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

    this.store = createStore(reducer);
    
    this.state = {
      models: Immutable.List([
        {id: 0, index: 0},
        {id: 1, index: 1},
        {id: 2, index: 2},
      ]),
      nextId: 3,
      line: [0, 0],
      data: this.store.getState().data
    };
    
    this.createNewModel = this.createNewModel.bind(this);
    this.handleSetValue = this.handleSetValue.bind(this);
    this.handleWindowMove = this.handleWindowMove.bind(this);
  }
  
  componentWillMount() {
    this.store.subscribe(() => {
      this.setState(state => ({
        data: this.store.getState().data
      }));
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
        {/*<svg id="background" width="100%" height="100%">
          <line x1="50%" y1="50%" x2={this.state.line[0]} y2={this.state.line[1]} stroke="hsl(0, 0%, 25%)" strokeWidth="1" />
        </svg>*/}
        <MenuBar onCreateNewModel={this.createNewModel} />
        
        <WindowManager>
          {this.state.models.map(model => {
            return (
              <Window key={model.id} id={model.id} onWindowMove={this.handleWindowMove}>
                <ModelContainer id={model.id} data={this.state.data} onSetValue={this.handleSetValue} />
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
    //console.log("zzz", props.data.get(0));
    
    this.state = {
      activeCell: 0
    };
    
    this.handleCellFocus = this.handleCellFocus.bind(this);
    this.handleCellEvent = this.handleCellEvent.bind(this);
  }

  handleCellFocus(index) {
    //console.log('handleCellFocus()', index);
    
    this.setState(state => ({
      activeCell: index
    }));
  }
  
  handleCellEvent(event) {
    //console.log('ModelContainer#handleEvent', event.key);
    
    const offset = (() => {
      switch (event.key) {
        case 'ArrowRight': return this.state.activeCell < 2 ? +1 : 0;
        case 'ArrowLeft':  return this.state.activeCell > 0 ? -1 : 0;
        default:           return 0;
      }
    })();
    
    if (offset !== 0) {
      this.setState(state => ({
        activeCell: state.activeCell + offset
      }), () => {
        this.handleCellFocus(this.state.activeCell);
      });
    }
  }
  
  render() {
    //console.log('ModelContainer#render()');
    
    return <ModelView data={this.props.data} onCellFocus={this.handleCellFocus} onCellEvent={this.handleCellEvent} onSetValue={this.props.onSetValue} activeCell={this.state.activeCell}/>;
  }

}


//
//
//

function ModelView(props) {
  return (
    <div>
      <CellContainer index={0} value={props.data.get(0)} active={props.activeCell === 0} onCellFocus={props.onCellFocus} onCellEvent={props.onCellEvent} onSubmit={props.onSetValue} />
      <CellContainer index={1} value={props.data.get(1)} active={props.activeCell === 1} onCellFocus={props.onCellFocus} onCellEvent={props.onCellEvent} onSubmit={props.onSetValue} />
      <CellContainer index={2} value={props.data.get(2)} active={props.activeCell === 2} onCellFocus={props.onCellFocus} onCellEvent={props.onCellEvent} onSubmit={props.onSetValue} />
    </div>
  );
}

    /*<ul>
      <li>
        <CellContainer index={0} value={props.data.get(0)} onSubmit={props.onSetValue} />
        <CellContainer index={1} value={props.data.get(1)} onSubmit={props.onSetValue} />
        <CellContainer index={2} value={props.data.get(2)} onSubmit={props.onSetValue} />
      </li>
      <li>
        <CellContainer index={3} value={props.data.get(3)} onSubmit={props.onSetValue} />
        <CellContainer index={4} value={props.data.get(4)} active={props.activeCell === 4} onCellEvent={props.onCellEvent} onSubmit={props.onSetValue} />
        <CellContainer index={5} value={props.data.get(5)} onSubmit={props.onSetValue} />
      </li>
      <li>
        <CellContainer index={6} value={props.data.get(6)} onSubmit={props.onSetValue} />
        <CellContainer index={7} value={props.data.get(7)} onSubmit={props.onSetValue} />
        <CellContainer index={8} value={props.data.get(8)} onSubmit={props.onSetValue} />
      </li>
    </ul>*/


//
// CellContainer handles UI state for CellView presentation components
//

export class CellContainer extends React.PureComponent {

  // Lifecycle Methods

  constructor(props) {
    super(props);
    
    this.state = {
      editing: false,
      value: props.value.toString(),
      modified: false
    };
    
    this.handleChange = this.handleChange.bind(this);
    this.handleFocus = this.handleFocus.bind(this);
    this.handleBlur = this.handleBlur.bind(this);
    this.handleKeyDown = this.handleKeyDown.bind(this);
  }

  componentDidMount() {
    if (this.props.active) {
      this.element.focus();
    }
  }

  componentWillReceiveProps(props) {
    //console.log('ppp', props.active === this.props.active);
    if (props.value === this.props.value && props.active === this.props.active) {
      return;
    }

    //console.log("props", this.props.value);
    
    this.setState(state => ({
      value: props.value.toString(),
    }));
    
    if (props.active) {
      //console.log('CellContainer#componentWillReceiveProps', this.element);
      
      setTimeout(() => {
        this.element.focus();
        this.element.select();
      }, 0);
    } else {
      this.element.blur();
    }
  }

  // Utility Methods

  submitValue() {
    if (this.props.onSubmit && this.state.modified) {
	  this.props.onSubmit(this.props.index, this.state.value);
    }
    
    this.setState(state => ({
      modified: false
    }));
  }

  // Handler Methods

  handleChange(event) {
    // Events can't be used asynchronously since they're recycled
    var target = event.target;
    
    this.setState(state => ({
      value: target.value
    }));
  }

  handleFocus(event) {
    this.props.onCellFocus(this.props.index);
  }

  handleBlur(event) {
    this.setState(state => ({
      editing: false
    }));

    this.submitValue();
  }

  handleKeyDown(event) {
    //console.log(event.key);

    if (!this.state.editing) {
      if (["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].indexOf(event.key) !== -1) {
        event.stopPropagation();
        event.preventDefault();

        this.props.onCellEvent(event);
        
        return;
      }
      
      if (event.key === 'Enter') {
        event.target.setSelectionRange(event.target.value.length, event.target.value.length);
        
        event.stopPropagation();
        event.preventDefault();
      }
      
      this.setState(state => ({
        editing: true
      }));

      this.originalValue = this.state.value;
    } else {
      if (event.key === 'Enter') {
        event.stopPropagation();
        event.preventDefault();

        event.target.select();

        this.setState(state => ({
          editing: false,
          modified: state.value !== this.originalValue
        }), () => {
          this.submitValue();
        });
      }
    }
  }

  render() {
    var style = this.props.active ? {
      border: "3px solid hsl(0, 0%, 25%)",
      position: "relative",
    } : { };

    return <input data-index={this.props.index} type="text" pattern="[0-9]" value={this.state.value} style={style} readOnly={!this.state.editing} ref={element => this.element = element}
                  onChange={this.handleChange} onFocus={this.handleFocus} onBlur={this.handleBlur} onKeyDown={this.handleKeyDown} />;
  }

}

ReactDOM.render(
  <App />,
  document.getElementById('app')
);
