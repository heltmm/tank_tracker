import React from 'react';

class Tank extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      modal: false
    };

    this.toggle = this.toggle.bind(this);
  }

  toggle() {
    this.setState({
      modal: !this.state.modal
    });
  }

  renderTank() {
    switch(this.props.tank.status) {
    case 'sanitized':
      return 'success'
      break;
    case 'clean':
      return 'info'
      break;
    case 'dirty':
      return 'danger'
      break;
    case 'active':
      return 'warning'
      break;
    default:
      break;
    }
  }



  render() {
    return (
      <div class='tank'>
        <p class='top-image'>{ this.props.tank.tank_type }{ this.props.tank.number }<br/>{this.props.tank.status}</p>
        <p class="centered-image">{ this.props.tank.initials }{ this.props.tank.gyle }<br/>{ this.props.tank.brand }<br/>{ this.props.tank.date_brewed}</p>
        <p class="bottom-image">{ this.props.tank.volume }</p>


      </div>
    );
  }
}

export default Tank;

// <div class="d-inline-block">
//   <div class='tank'>
//     <p class='top-image'><%= tank.tank_type %><%= tank.number %><br><%= tank.status%></p>
//     <% case tank.status %>
//     <% when "sanitized" %>
//       <% type = 'success' %>
//       <p class="centered-image"><%= tank.initials %></p>
//     <% when "clean" %>
//       <% type = 'info' %>
//       <p class="centered-image"><%= tank.initials %></p>
//     <% when "dirty" %>
//       <% type = 'danger' %>
//     <% when "active" %>
//       <% type = 'warning' %>
//       <p class="centered-image"><%= tank.gyle %><br>
//       <%= tank.brand %><br>
//       <%= tank.date_brewed %></p>
//       <p class="bottom-image"><%= tank.volume %></p>
//     <% else %>
//          <% type = '' %>
//     <% end %>
//
//     <% if tank.tank_type === "FV" %>
//       <%= image_tag('fv.png', class: "bg-#{type}")%>
//     <% else %>
//       <%= image_tag('BBT.png', class: "bg-#{type}")%>
//     <% end %>
//   </div>
// </div>
