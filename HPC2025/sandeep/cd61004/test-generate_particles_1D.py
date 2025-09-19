import matplotlib.pyplot as plt
import numpy as np

# Function to plot rectangular box
def plot_box():
    plt.plot([0, 5], [0, 0], 'k-')  # bottom line
    plt.plot([0, 5], [1, 1], 'k-')  # top line
    plt.plot([0, 0], [0, 1], 'k-')  # left line
    plt.plot([5, 5], [0, 1], 'k-')  # right line

# Function to color the sub-cells
def color_sub_cells():
    plt.fill_between([1, 2], 0, 1, color='lightgray', alpha=0.5)
    plt.fill_between([2, 3], 0, 1, color='lightblue', alpha=0.5)
    plt.fill_between([3, 4], 0, 1, color='lightgreen', alpha=0.5)
    plt.fill_between([4, 5], 0, 1, color='lightyellow', alpha=0.5)

# Function to add particles randomly with labels
def add_particles(num_particles):
    x = np.random.uniform(0.4, 4.7, num_particles)
    y = np.random.uniform(0.05, 0.9, num_particles)
    numbers = list(range(1, num_particles + 1))
    np.random.shuffle(numbers)
    for i, (x_, y_, number) in enumerate(zip(x, y, numbers)):
        plt.scatter(x_, y_, color='blue')
        plt.text(x_+0.01, y_+0.01, f'{number}', color='black', fontname='Arial', fontsize=12)

# Main function to create the plot
def main():
    plt.figure(figsize=(12, 6))
    plt.xlim(0, 5)
    plt.ylim(0, 1)
    plt.gca().set_aspect('equal', adjustable='box')
    plot_box()
    color_sub_cells()
    add_particles(20)
    plt.xlabel('Cell parameter')
    plt.ylabel('Y')
    plt.title('Particles in a Rectangular Box')
    plt.savefig('cell-list.pdf')  # Save the figure as PDF

 #   plt.show()

if __name__ == "__main__":
    main()

