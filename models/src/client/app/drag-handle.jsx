import React from 'react';


//
// DragHandle
//

export default class DragHandle extends React.PureComponent {

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
