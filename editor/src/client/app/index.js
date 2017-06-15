import React from 'react';  
import ReactDOM from 'react-dom';
import Immutable from 'immutable';
import RxJS from 'rxjs';


  const command$ = new RxJS.Subject();
  const action$ = RxJS.Observable.merge(command$);

  // Initial State
  const initState = Immutable.Map({ name: 'Harry' });

  const store$ = action$.startWith(initState).scan((state, action) => {
    return action(state);
  });


class Button extends React.Component {

  constructor(props) {
    super(props);

    this.onClick = props.onClick;
  }

  handleOnClick() {
    command$.next(this.onClick());
  }

  render() {
    return (
      <button onClick={() => this.handleOnClick()}>Foo</button>
    );
  }

}


class App extends React.Component {

  constructor(props) {
    super(props);

    this.state = { }
  }

  componentDidMount() {
    console.log("here 1");
    store$.subscribe(storeState => {
      console.log("here");

      this.setState((state, props) => {
        return { name: storeState.get('name') };
      });
    });

  }

  subscriptions() {
    return RxJS.Observable.fromEvent(document, 'keypress').map(event => {
      return this.insertChar(event.key);
    });
  }

  changeName(name) {
    command$.next(Actions.NAME_CHANGED(name));
  }

  insertChar(char) {
    return (state) => state.update('name', name => name + char);
  }

  render() {
    console.log("render()");
    return (
      <div>
        <div>{this.state.name}</div>
        <button onClick={() => this.changeName('Harry')} >Harry</button>
        <Button onClick={() => this.insertChar('x')} >Sally</Button>
      </div>
    );
  }

}


// subscribe and render the view
const dom = document.getElementById('app');

ReactDOM.render(<App />, dom);
