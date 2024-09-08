# Algorithms Visualization Project

This project is an interactive web-based platform for visualizing various algorithms, with a focus on pathfinding algorithms. Built using Elixir and Phoenix LiveView, it allows users to interact with and observe the behavior of different algorithms in real-time.

## Features

- Interactive grid where users can add/remove walls by clicking
- Draggable start and end points
- Real-time visualization of the A\* algorithm's search process
- Responsive full-screen design
- Clear and restart functionality

## Prerequisites

Before you begin, ensure you have the following installed:

- Elixir (version 1.14 or later)
- Phoenix Framework (version 1.7 or later)
- Node.js (version 14 or later)

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/yourusername/astar_visualizer.git
   cd astar_visualizer
   ```

2. Install dependencies:

   ```
   mix deps.get
   cd assets && npm install && cd ..
   ```

3. Create and migrate the database:
   ```
   mix ecto.create && mix ecto.migrate
   ```

## Running the Application

To start the Phoenix server:

1. Start the server:

   ```
   mix phx.server
   ```

2. Visit [`localhost:4000`](http://localhost:4000) in your browser.

## Usage

1. **Adding/Removing Walls**: Click on cells to toggle walls on and off.
2. **Setting Start/End Points**: Drag the 'S' (Start) and 'G' (Goal) markers to desired positions.
3. **Start Pathfinding**: Click the "Start Pathfinding" button to visualize the A\* algorithm.
4. **Clear Grid**: Use the "Clear Grid" button to reset the visualization.

## How It Works

The application uses Phoenix LiveView to create a real-time, interactive grid. The A\* algorithm is implemented in Elixir and visualized step-by-step on the grid. The algorithm finds the shortest path between the start and goal points while avoiding walls.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Acknowledgments

- Phoenix Framework and the Elixir community
- All contributors who have helped with the project

## Support

If you encounter any problems or have any questions, please open an issue in the GitHub repository.
