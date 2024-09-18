import Foundation

// Arrays to store multiple barriers and targets
var barriers: [Shape] = []
var targets: [Shape] = []
var hitTargets = 0

let circle = OvalShape(width: 50, height: 50)
let ball = circle

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

// Function for when the ball (circle) collides with a target
func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    otherShape.fillColor = .green
}

// Function to add a target at a specific position
fileprivate func addTarget(at position: Point) {
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    let target = PolygonShape(points: targetPoints)
    targets.append(target)

    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    target.name = "target"

    scene.add(target)
}

// Function to add a barrier with specific parameters
fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    let barrier = PolygonShape(points: barrierPoints)
    barriers.append(barrier)
    barrier.fillColor = .brown
    barrier.position = position
    barrier.angle = angle
    barrier.hasPhysics = true
    barrier.isImmobile = true
    scene.add(barrier)
}

// Function to handle when the ball (circle) exits the scene
func ballExitedScene() {
    // Check if all targets are hit
    hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!", completion: alertDismissed)
    }
    
    // Make barriers draggable after the ball exits
    for barrier in barriers {
        barrier.isDraggable = true
    }
}

// Function to reset the ball's (circle's) position
func resetGame() {
    circle.position = Point(x: 0, y: -80)
}

// Function to print the position of a shape
func printPosition(of shape: Shape) {
    print(shape.position)
}

// Function to set up the ball (circle)
fileprivate func setupBall() {
    circle.position = Point(x: 250, y: 400)
    scene.add(circle)
    circle.hasPhysics = true
    circle.onCollision = ballCollided(with:)
    circle.isDraggable = false
    scene.trackShape(circle)
    circle.onExitedScene = ballExitedScene
    circle.onTapped = resetGame
    resetGame()
    circle.bounciness = 0.6
}

// Function to set up the funnel
fileprivate func setupFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
}

// Empty function to handle alert dismissal
func alertDismissed() {
    // No further action required
}

// Setup function to initialize the game elements
func setup() {
    setupBall()
    setupFunnel()

    // Adding barriers with example positions, widths, heights, and angles
    addBarrier(at: Point(x: 175, y: 100), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 30, height: 15, angle: -0.2)
    addBarrier(at: Point(x: 325, y: 150), width: 100, height: 25, angle: 0.03)

    // Adding targets with example positions
    addTarget(at: Point(x: 184, y: 563))
    addTarget(at: Point(x: 238, y: 624))
    addTarget(at: Point(x: 269, y: 453))
    addTarget(at: Point(x: 213, y: 348))
    addTarget(at: Point(x: 113, y: 267))

    // Function to drop the ball (circle) from the funnel and reset targets
    func dropBall() {
        circle.position = funnel.position
        circle.stopAllMotion()

        // Reset all targets to yellow
        for target in targets {
            target.fillColor = .yellow
        }

        // Make barriers non-draggable when the ball is dropped
        for barrier in barriers {
            barrier.isDraggable = false
        }
    }

    scene.onShapeMoved = printPosition(of:)
    funnel.onTapped = dropBall
    circle.fillColor = .blue
}
