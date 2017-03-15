
window.SimDrive = {}

road = [
	{ length: 500, angle: 60 }
]

class Path

	constructor: () ->
		@segments = []
		
	addSegment: (scene, segment) ->
		if @segments.length > 0
			lastSegment = @segments[@segments.length - 1]
			connectionPoint = lastSegment.connectionPoint()

			angle = @segments.reduce ((angle, segment) -> angle + -segment.angle), 0
			console.log(angle)
			segment.object.position.set(connectionPoint.x, 0, connectionPoint.z)
			segment.object.rotation.y = angle * (Math.PI / 180)

		@segments.push(segment)
		scene.add(segment.object)


class Segment

	constructor: (data) ->
		@length = data.length
		@angle  = data.angle

		@geometry = new THREE.Geometry()
		material = new THREE.MeshBasicMaterial({color: 0x808080, shading: THREE.FlatShading, overdraw: true})

		length = @length / 2
		angle = @angle * (Math.PI / 180) || 0.0000000000001
		radius = length * (1 / angle)
		
		for i in [0..length]
			theta = angle / length * i
			#vector1 = new THREE.Vector3( Math.cos(theta) * (radius + 25) - radius, i / length * 50, Math.sin(theta) * (radius + 25) )
			#vector2 = new THREE.Vector3( Math.cos(theta) * (radius - 25) - radius, i / length * 50, Math.sin(theta) * (radius - 25) )
			vector1 = new THREE.Vector3( Math.cos(theta) * (radius + 25) - radius,  1, Math.sin(theta) * (radius + 25) )
			vector2 = new THREE.Vector3( Math.cos(theta) * (radius - 25) - radius,  1, Math.sin(theta) * (radius - 25) )

			@geometry.vertices.push( new THREE.Vertex( vector1 ) )
			@geometry.vertices.push( new THREE.Vertex( vector2 ) )

		@asphalt = new THREE.Ribbon(@geometry, material)

		material = new THREE.MeshBasicMaterial({color: 0x000000, shading: THREE.FlatShading, overdraw: true, opacity: 0.25, transparent: true})
		@shadow = new THREE.Ribbon(@asphalt.geometry, material)
		@shadow.position.set(0, 0.025, 0)
		@shadow.scale.set(1, 0.025, 1)
		
		geometry = new THREE.CubeGeometry(100, 0, 0)
		material = new THREE.MeshBasicMaterial({color: 0xffffff, shading: THREE.FlatShading, overdraw: true, wireframe: true})

		cube = new THREE.Mesh(geometry, material)
		cube.position.set(0, 1.025, 0)

		@object = new THREE.Object3D()
		@object.add(cube)
		@object.add(@asphalt)
		@object.add(@shadow)

	connectionPoint: () ->
		vertex1 = @geometry.vertices[@geometry.vertices.length - 1]
		vertex2 = @geometry.vertices[@geometry.vertices.length - 2]

		vector = new THREE.Vector3().add(vertex1.position, vertex2.position).multiplyScalar(0.5)
		
		x = vector.x * Math.cos(-@object.rotation.y) - vector.z * Math.sin(-@object.rotation.y)
		z = vector.z * Math.cos(-@object.rotation.y) + vector.x * Math.sin(-@object.rotation.y)
		vector3 = new THREE.Vector3(x, 0, z)

		return new THREE.Vector3().add(vector3, @object.position)

		
class window.SimDrive.World
	@path = new Path()
	@scene = new THREE.Scene()

	@camera = new THREE.PerspectiveCamera(fov = 60,
									   aspect = window.innerWidth / window.innerHeight,
									     near = 1,
									      far = 10000)
	@camera.position.set(0, 500, 0)
	@camera.lookAt(new THREE.Vector3(0, 0, 0))
	@scene.add(this.camera)

	@path.addSegment(@scene, new Segment({ length: 200, angle: +60 }))
	@path.addSegment(@scene, new Segment({ length: 200, angle: +0 }))
	@path.addSegment(@scene, new Segment({ length: 200, angle: -90 }))
	@path.addSegment(@scene, new Segment({ length: 200, angle: +0 }))
	@path.addSegment(@scene, new Segment({ length: 200, angle: +60 }))
	@path.addSegment(@scene, new Segment({ length: 200, angle: +60 }))
	@path.addSegment(@scene, new Segment({ length: 200, angle: +60 }))
	@path.addSegment(@scene, new Segment({ length: 400, angle: +0 }))

	@ground = (() =>
		geometry = new THREE.PlaneGeometry(1000, 1000, 1, 1)
		material = new THREE.MeshBasicMaterial({color: 0x008000, shading: THREE.FlatShading, overdraw: true})

		new THREE.Mesh(geometry, material))()

	@ground.rotation.set(-Math.PI / 2, 0, 0)
	
	@scene.add(@ground)

	@renderer = new THREE.WebGLRenderer({antialias: true})
	@renderer.setSize(window.innerWidth, window.innerHeight)
			
	document.body.appendChild(@renderer.domElement)

	@render: () =>
		@renderer.render(@scene, @camera)
	