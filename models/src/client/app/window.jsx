import React from 'react';
import Immutable from 'immutable';

import DragHandle from './drag-handle';

//
// Window
//

export default class Window extends React.PureComponent {

  constructor(props) {
    super(props);
    
    this.state = {
      position: {
        x: Window.nextPosition.x,
        y: Window.nextPosition.y
      }
    }
    
    this.handleMouseDown = this.handleMouseDown.bind(this);   
    this.handleDrag = this.handleDrag.bind(this);

    Window.nextPosition = {
      x: Window.nextPosition.x + 20,
      y: Window.nextPosition.y + 60
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
    //console.log("Window#render()");

    var style = {
      left: this.state.position.x + 'px',
      top: this.state.position.y + 'px',
      zIndex: this.props.zIndex,
      outline: this.props.active ? '1px solid hsla(0, 0%, 25%, 1)' : ''
    };
    
    return (
      <div className="model" style={style} onMouseDown={this.handleMouseDown}>
        <DragHandle onDrag={this.handleDrag}>
          <h1>Model</h1>
        </DragHandle>
        {React.Children.only(this.props.children)}
      </div>
    );
  }
  
}

Window.nextPosition = { x: 20, y: 45 }
