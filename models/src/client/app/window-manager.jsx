import React from 'react';
import Immutable from 'immutable';


//
// WindowManager
//

export default class WindowManager extends React.PureComponent {

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

