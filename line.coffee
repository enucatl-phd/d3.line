class d3.chart.Line extends d3.chart.BaseChart

    constructor: ->
        @accessors = {} unless @accessors?
        @accessors.interpolation = "linear"
        @accessors.x_value = (d) -> d.x
        @accessors.y_value = (d) -> d.y
        @accessors.color_value = (d) -> d.name
        @accessors.color_scale = d3.scale.category20()
        super

    _draw: (element, data, i) ->
                 
        # convenience accessors
        width = @width()
        height = @height()
        margin = @margin()
        interpolation = @interpolation()
        x_value = @x_value()
        y_value = @y_value()
        x_scale = @x_scale()
        y_scale = @y_scale()
        color_value = @color_value()
        color_scale = @color_scale()

        # get unique color names
        color_names = (data.map color_value).filter (d, i, self) ->
            self.indexOf d == i

        color_scale.domain color_names

        # update scales
        x_scale.range [0, width]
        y_scale.range [height, 0]

        # select the svg if it exists
        svg = d3.select element
            .selectAll "svg"
            .data [data]

        # otherwise create the skeletal chart
        g_enter = svg.enter()
            .append "svg"
            .append "g"

        # update the dimensions
        svg
            .attr "width", width + margin.left + margin.right
            .attr "height", height + margin.top + margin.bottom

        # update position
        g = svg.select "g"
            .attr "transform", "translate(#{margin.left}, #{margin.top})"

        g
            .selectAll ".paths"
            .data [data]
            .enter()
            .append "g"
            .classed "paths", true

        # update lines
        lines = g.select ".paths"
            .selectAll ".path"
            .data (d) -> d

        lines
            .enter()
            .append "path"
            .classed "path", true

        lines
            .attr "stroke", (d) -> color_scale(d.name)
            .attr "d", (d) -> (d3.svg.line()
                .interpolate interpolation
                .x (e) -> x_scale x_value e
                .y (e) -> y_scale y_value e
                )(d.values)

        lines
            .exit()
            .remove()
